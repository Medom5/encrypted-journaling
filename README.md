# Encrypted Journaling Automation Script

This Bash script automates the encryption and decryption of a personal journal file using GPG2. It provides a secure and easy way to maintain a private digital journal. The script was originally a personal project that I later developed into something I believe could benefit others while also enhancing my scripting skills.

## Features

- **Encrypt/Decrypt Journal**: Easily encrypt or decrypt the journal file using GPG2.
- **Automatic Backup**: Backs up encrypted files before decrypting.
- **Logging**: Logs all encryption and decryption activities for debugging and tracking.

## TODO

- [x] Add logging functionality.
- [ ] Implement automatic date appending when editing the journal.
- [ ] Implement multiple journal support by allowing users to specify different journal names.
- [ ] Add an integrity check to ensure journal content remains unaltered.
- [ ] Enhance error handling with more user-friendly messages.
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
git clone https://github.com/Medom5/encrypted-journaling.git
cd encrypted-journaling
```

## Permissions Setup

Ensure the script has execute permissions:

```bash
chmod +x journal.sh
```

## Configuration

1. Install GPG2: If you haven't installed GPG2 yet, follow the installation instructions above for your platform.

2. Passphrase Setup: The script uses symmetric encryption for file encryption. This means you will need to provide a passphrase when encrypting and decrypting the journal file. Choose a strong passphrase and keep it secure, as it is the key to accessing your encrypted journal.

3. Directory Setup: The script will use a directory for the journal file located at $HOME/journaling. This directory will be created automatically if it doesn’t already exist.

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

All actions, such as encryption and decryption, are logged to a log file located at journal.log in the same directory. You can check this log for activity tracking and debugging purposes.

## Contributing

Feel free to fork the repository and create a pull request if you would like to contribute improvements or fixes. Contributions are welcome!
