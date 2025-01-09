#!/bin/bash
# journal.sh: Automate GPG2 encryption and decryption for journal file

JOURNAL_DIR="$HOME/journaling"
JOURNAL_FILE="$JOURNAL_DIR/journal.txt"
ENCRYPTED_FILE="$JOURNAL_DIR/journal.txt.gpg"
LOG_FILE="$JOURNAL_DIR/journal.log"

# Ensure the JOURNAL_DIR exists
mkdir -p "$Journal_DIR"

# Logging function
log_action() {
    local action="$1" 
    local message="$2" # Optional message
    local date_format="%Y-%m-%d %H:%M:%S" # YYYY-MM-DD HH:MM:SS 
    echo "(date +$date_format) [${action^^}]  $message" >> "$LOG_FILE"
}

function edit_journal() {
    # Decrypt the journal
    if [ -f "$ENCRYPTED_FILE" ]; then
    	cp "$ENCRYPTED_FILE" "$JOURNAL_DIR/gpg.bak" # Backup current encrypted file
        gpg --pinentry-mode loopback -o "$JOURNAL_FILE" -d "$ENCRYPTED_FILE"
        if [ $? -ne 0 ]; then
	    echo "Decryption failed. Aborting."
	    return
	fi
    else 
	echo "No existing journal found. Creating a new one, happy journaling..."
	sleep 2
    fi

    # Open the decrypted journal for editing
    nano "$JOURNAL_FILE"

    # Proceed if only user saved the file ( size > 0)
    if [ -f "$JOURNAL_FILE" ] && [ -s "$JOURNAL_FILE" ]; then
        # Re-encrypt journal.txt and overwrite it if already exists
        gpg --yes --pinentry-mode loopback -o "$ENCRYPTED_FILE" -c "$JOURNAL_FILE"

        if [ $? -eq 0 ]; then
            echo "Journal encrypted successfully."
	    rm "$JOURNAL_FILE"
        else 
	    echo "Encryption Failed. Raw file not deleted"
        fi 
    else
	echo "Journal file is empty or doesn't exist. Not encrypting."
    fi
}

function view_journal() {
    log_action "view" "Starting journal viewing process."
    # Decrypt and display the journal
    if [ -f "$ENCRYPTED_FILE" ]; then
        gpg --pinentry-mode loopback -d "$ENCRYPTED_FILE"
        if [ $? -eq 0]; then
            log_action "view" "Journal viewed successfully."
        else
            log_action "view" "Failed to decrypt journal."
        fi
    else
	    echo "No encrypted journal found."
    fi
}


function usage() {
    echo "Usage:  $0 [edit|view]"
    echo "  edit: Decrypt and edit the journal."
    echo "  view: Decrypt and view the journal."
}



# Main 
case "$1" in 
    edit)
	edit_journal
	;;
    view)
	view_journal
	;;
    *)
	usage
	;;
esac
