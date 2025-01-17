# Encrypted Journaling Automation Script

## Demo

![Project Demo](assets/bash.gif)

This Bash script automates the encryption and decryption of a personal journal file using GPG2. It provides a secure and easy way to maintain a private digital journal. The script was originally a personal project that I later developed into something I believe could benefit others while also enhancing my scripting skills.

## Features

- **Encrypt/Decrypt Journal**: Easily encrypt or decrypt the journal file using GPG2.
- **Automatic Backup**: Backs up encrypted files before decrypting.
- **Logging**: Logs all encryption and decryption activities for debugging and tracking.
- **Unit Testing**: Includes unit tests using shunit2 to verify the correctness of the script's functions.

## TODO

- [x] Add Unit testing.
- [x] Add logging functionality.
- [x] Implement automatic date appending when editing the journal.
- [ ] Add a Cleanup Mechanism to Handle Script Interruptions.
- [ ] Add an integrity check to ensure journal content remains unaltered.
- [ ] Improve security by storing decrypted files in secure temporary locations (e.g., `/dev/shm`).

## Installation

### Prerequisites

Before using this script, make sure you have the following installed:

- [GPG2](https://gnupg.org/)

  - On Ubuntu/Debian: `sudo apt install gnupg2`
  - On macOS (using Homebrew): `brew install gnupg`
  - On Arch Linux: `sudo pacman -S gnupg`

- Bash shell (Linux/macOS): The script uses Bash, which is available on most Linux and macOS systems by default.

### Clone the Repository

```bash
cd encrypted-journaling
```

## Permissions Setup

Ensure the script has execute permissions:

git clone https://github.com/Medom5/encrypted-journaling.git

```bash
chmod +x journal.sh
```

## Configuration

1. Install GPG2: If you haven't installed GPG2 yet, follow the installation instructions above for your platform.

2. Passphrase Setup: The script uses symmetric encryption for file encryption. This means you will need to provide a passphrase when encrypting and decrypting the journal file. Choose a strong passphrase and keep it secure, as it is the key to accessing your encrypted journal.

3. Directory Setup: The script will use a directory for the journal file located at `$HOME/journaling`. This directory will be created automatically if it doesn’t already exist.

## Usage

### Editing the Journal

To edit your journal, run:

```bash
./journal.sh edit
```

This will decrypt your journal, open it in a text editor, and then re-encrypt it after you save and exit the editor.

### Viewing the Journal

To view your journal without editing, use:

```bash
./journal.sh view
```

This will decrypt and display the journal in the terminal.

## Logs

All actions, such as encryption and decryption, are logged to a log file located at `journal.log` in the same directory. You can check this log for activity tracking and debugging purposes.

To review log:

```bash
./journal.sh logs
```

## Testing

The script includes unit tests to verify the correctness of its functionality. You can use shunit2 as the testing framework to ensure that the script behaves as expected.

### Prerequisites

Before running the tests, make sure you have the following installed:

- **shunit2**: The testing framework for running bash unit tests.

  - On Ubuntu/Debian: `sudo apt install shunit2`
  - On macOS (using Homebrew): `brew install shunit2`
  - On Arch Linux: `sudo pacman -S shunit2`

- **GPG2**: If you haven't installed GPG2 yet, follow the instructions in the [Installation section](#installation).

## Running Tests

1. Clone the repository and change into the project directory (if you haven't already):

```bash
git clone https://github.com/Medom5/encrypted-journaling.git
cd encrypted-journaling
```

2. Make the Scripts Executable:

```bash
chmod +x journal.sh ./tests/test_journal.sh
```

3. To run the tests:

```bash
./journal.sh test
```

- This will automatically run all the unit tests in the script using `shunit2`. The test results will be displayed in the terminal.
- The setup function ensures the test environment is properly configured and cleaned up before and after each test.
- It also sets the required `JOURNAL_DIR` for the test and configures the `GPG_PASS` for the encryption.

## Contributing

Feel free to fork the repository and create a pull request if you would like to contribute improvements or fixes. Contributions are welcome!
