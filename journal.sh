#!/bin/bash
# journal.sh: Automate GPG2 encryption and decryption for journal file


JOURNAL_DIR="$HOME/journaling"
JOURNAL_FILE="$JOURNAL_DIR/journal.txt"
ENCRYPTED_FILE="$JOURNAL_DIR/journal.txt.gpg"
LOG_FILE="$JOURNAL_DIR/journal.log"
LOG_VIEWER="cat"
VIEWER="less"
MY_EDITOR="nano"
DATE=$(date '+%Y-%m-%d %A | %H:%M')

# don't change the the values(for testing)
NON_INTERACTIVE_MODE=false
GPG_PASS=""
GPG_OPTIONS="--pinentry-mode loopback" # can be changed if you know what you are doing

# Check if NON_INTERACTIVE_MODE is set to true
if [ "$NON_INTERACTIVE_MODE" == "true" ]; then
	MY_EDITOR="true" # Skip the editor
	GPG_PASS="testpass" # Set a test passphrase
fi

if [ -n "$GPG_PASS" ]; then
	GPG_OPTIONS="--pinentry-mode loopback --passphrase $GPG_PASSPHRASE"

# Ensure the JOURNAL_DIR exists
mkdir -p "$JOURNAL_DIR"

# Logging function
log_action() {
    local action="$1" 
    local message="$2" # Optional message
    local date_format="+%Y-%m-%d %H:%M:%S" # YYYY-MM-DD HH:MM:SS 
    echo "$(date "$date_format") [${action^^}]  $message" >> "$LOG_FILE"
}

function append_date() {
echo -e "╔═══════════════════════════════╗\n   $DATE \n╚═══════════════════════════════╝" >> "$JOURNAL_FILE"
}
function edit_journal() {
    log_action "edit" "Starting journal editing process."

    # Decrypt the journal
    if [ -f "$ENCRYPTED_FILE" ]; then

    	cp "$ENCRYPTED_FILE" "$JOURNAL_DIR/gpg.bak" # Backup current encrypted file
        gpg "$GPG_OPTIONS" -o "$JOURNAL_FILE" -d "$ENCRYPTED_FILE"

        if [ $? -ne 0 ]; then
	        log_action "error" "Decryption failed."
            echo "Decryption failed. Aborting."
	        return
	    fi
        log_action "decrypt" "Decrypted journal file successfully."
    else
        log_action "create" "No existing journal found. Creating a new journal."
	    echo "No existing journal found. Creating a new one, happy journaling..."
	    sleep 2
    fi

	# Appends the current date and time to mark the beginning of each session
	append_date
    # Open the decrypted journal for editing
    $MY_EDITOR "$JOURNAL_FILE"
    log_action "edit" "User edited the journal."

    # Proceed if only user saved the file ( size > 0)
    if [ -f "$JOURNAL_FILE" ] && [ -s "$JOURNAL_FILE" ]; then
        # Re-encrypt journal.txt and overwrite it if already exists
        gpg --yes "$GPG_OPTIONS" -o "$ENCRYPTED_FILE" -c "$JOURNAL_FILE"

        if [ $? -eq 0 ]; then
	        rm "$JOURNAL_FILE"
            log_action "encrypt" "Journal encrypted successfully and raw file deleted."
            echo "Journal encrypted successfully."
        else 
    	    log_action "error" "Encryption failed. Raw file not deleted."
            echo "Encryption Failed. Raw file not deleted"
        fi 
    else
        log_action "warning" "Journal file is empty or doesn't exist. Not encrypting."
    	echo "Journal file is empty or doesn't exist. Not encrypting."
    fi
    log_action "edit" "Journal editing process completed."
}

function view_journal() {
    log_action "view" "Starting journal viewing process."
    
    # Decrypt and display the journal
    if [ -f "$ENCRYPTED_FILE" ]; then
        gpg "$GPG_OPTIONS" -d "$ENCRYPTED_FILE" | $VIEWER
        if [ $? -eq 0 ]; then
            log_action "view" "Journal viewed successfully."
        else
            log_action "view" "Failed to decrypt journal."
        fi
    else
        log_action "error" "No encrypted journal found for viewing."
	    echo "No encrypted journal found."
    fi
}

function view_logs() {
    # Proceed if only log file exists ( size > 0)
    if [ -f "$LOG_FILE" ]; then
        $LOG_VIEWER "$LOG_FILE"
    else
        echo "No logs found."
    fi
}

function usage() {
    echo "Usage:  $0 [edit|view|logs]"
    echo "  edit: Decrypt and edit the journal."
    echo "  view: Decrypt and view the journal."
    echo "  logs: View journal logs."
}



# Main 
case "$1" in 
    edit)
	edit_journal
	;;
    view)
	view_journal
	;;
    logs)
    view_logs
    ;;
    *)
	usage
	;;
esac
