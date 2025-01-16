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

# Check for GPG2
if ! command -v gpg2 &> /dev/null; then
    echo "GPG2 is required but not found. Please install GPG2."
    exit 1
fi


# Ensure the JOURNAL_DIR exists
mkdir -p "$JOURNAL_DIR"

function gpg_enc() {
	gpg --yes --pinentry-mode loopback -o "$ENCRYPTED_FILE" -c "$JOURNAL_FILE"
}

function gpg_dec() {
	local output_file="$1" # Optional: if set, decrypt ato this file, otherwise output to stdout
	if [ -z "$output_file" ]; then
		# No output file provided, so output to stdout for viewing
		gpg --pinentry-mode loopback -d "$ENCRYPTED_FILE"
	else
		# Output to the specified file for editig
		gpg --pinentry-mode loopback -o "$JOURNAL_FILE" -d "$ENCRYPTED_FILE"
	fi
}

# Logging function
function log_action() {
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
        gpg_dec "$JOURNAL_FILE"
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
        gpg_enc
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
    	gpg_dec | $VIEWER
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
