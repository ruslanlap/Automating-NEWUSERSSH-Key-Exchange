# User Setup Script with SSH

This is a bash script that automates the setup of a user account on a Linux system. It prompts the user for login credentials, the path to an SSH public key, and then creates the necessary directories, sets up SSH, and adds the user to the system.

## Usage

To use this script, follow these steps:

1. Open a terminal.
2. Copy the script into a file named `user_setup.sh`.
3. Make the script executable by running the command `chmod +x user_setup.sh`.
4. Run the script using the command `./user_setup.sh`.

## Script Explanation

The script starts by defining ANSI color codes and emojis for better readability. It then defines a function `loading_animation()` that displays a loading animation while the script is running.

The script uses `echo` statements to display messages to the user, such as "Starting user setup..." and "User setup completed successfully!". It also uses `sleep` to introduce delays between messages.

The script prompts the user for their login, password, and the path to their SSH public key using the `read` command. The `-p` option is used to display a prompt, and the `-s` option is used to hide the password input.

After obtaining the necessary information, the script creates the user's home directory and the `.ssh` directory. It appends the contents of the SSH public key file to the `authorized_keys` file in the `.ssh` directory. It then copies the contents of the `/etc/skel` directory to the user's home directory, creates the user account using `useradd`, sets the ownership of the home directory to the new user, and sets the user's password using `chpasswd`.

Finally, the script checks if the user was successfully added by searching for the user's login in the `/etc/passwd` file. It displays a message indicating the completion of the user setup.

## Running the Script

To run the script, follow these steps:

1. Open a terminal.
2. Navigate to the directory where the script is located.
3. Make the script executable by running the command `chmod +x autosshconnect.sh`.
4. Run the script using the command `./autosshconnect.sh`.

Please note that this script requires administrative privileges to create the user account and modify system files.
