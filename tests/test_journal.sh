#!/bin/bash

#set -x  # for Debugging
 

SHUNIT2=$(which shunit2)


if [ -z "$SHUNIT2" ]; then
    echo "shunit2 not found. Please install it (e.g., via your package manager)."
    exit 1
fi 

# Set up test environment
function setup() {


    # Source the journal script quietly and set the test directory
    source ./journal.sh > /dev/null 2>&1
    
  	export TEST_DIR="/tmp/journaling_test"
    export JOURNAL_DIR="$TEST_DIR"
    export JOURNAL_FILE="$JOURNAL_DIR/journal.txt"
    export ENCRYPTED_FILE="$JOURNAL_DIR/journal.txt.gpg"
    export LOG_FILE="$JOURNAL_DIR/journal.log"
    export GPG_PASS="testpass"  # Override passphrase for testing

	# Clean up old test data
	rm -rf "$TEST_DIR"
	mkdir -p "$TEST_DIR"

}

function teardown() {
    rm -rf "$TEST_DIR"  # Clean up
}

function test_gpg_enc() {
    echo "Test entry" > "$JOURNAL_FILE"
    gpg_enc
    assertTrue "Encrypted file not created" "[ -f $ENCRYPTED_FILE ]"
    assertTrue "Encrypted file is empty" "[ -s $ENCRYPTED_FILE ]"
}

function test_gpg_dec() {
    echo "Test entry" > "$JOURNAL_FILE"
    gpg_enc
    decrypted_content=$(gpg_dec)
    assertEquals "Decryption failed" "Test entry" "$decrypted_content"
}

function test_append_date() {
    append_date
    assertTrue "Journal file not created" "[ -f $JOURNAL_FILE ]"
    assertTrue "Date not appended" "grep -q '$(date '+%Y-%m-%d %A | %H:%M')' $JOURNAL_FILE"
}

function test_view_logs() {
    log_action "test" "Log test entry"
    assertTrue "Log file not created" "[ -f $LOG_FILE ]"
    assertTrue "Log entry not found" "grep -q 'Log test entry' $LOG_FILE"
}

function test_usage() {
    output=$(usage)
    echo "$output" | grep -q "Usage:"
    assertTrue "Usage function missing usage information" "[ $? -eq 0 ]"
}

# Load shunit2 and run tests
trap teardown EXIT  # Ensure cleanup happens at the end
setup
. "$SHUNIT2"         # Run the tests
