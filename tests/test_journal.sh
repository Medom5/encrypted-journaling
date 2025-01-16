#!/bin/bash

#set -x  # for Debugging
 

SHUNIT2=$(which shunit2)

TEST_DIR="/tmp/journaling_test"

# Set up test environment
function setup() {

    # Clean up old test data
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR"

    # Source the journal script and set the test directory
    source ./journal.sh
    export JOURNAL_DIR="$TEST_DIR"  # Override JOURNAL_DIR for tests
    export GPG_PASS="testpass"      # Set the GPG passphrase for tests
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
    assertTrue "Usage function missing usage information" "echo \"$output\" | grep -q 'Usage:'"
}

# Load shunit2 and run tests
setup
trap teardown EXIT  # Ensure cleanup happens at the end
. "$SHUNIT2"         # Run the tests
