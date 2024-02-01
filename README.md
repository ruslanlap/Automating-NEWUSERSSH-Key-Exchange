# Automating-SSH-Key-Generation-and-Exchange

                                                                                                                                                                                
                                                                                                                                                                                
Here is a description of the repository's purpose in English:

# Automating SSH Key Generation and Exchange

This repository contains a Bash script that automates the process of generating SSH keys and copying the public key to a remote server to enable passwordless SSH logins using key-based authentication.

The script does the following:

1. Generates a new SSH key pair (public and private keys) using the rsa algorithm. The keys are stored as id_rsa and id_rsa.pub in the ~/.ssh directory.

2. Reads the content of the generated public key (id_rsa.pub).

3. Connects via SSH to the remote server using username and IP address provided.

4. Creates the .ssh directory on the remote server if it doesn't exist.

5. Appends the public key data to the authorized_keys file on the remote server. This allows the user to authenticate using the private key.

6. Sets appropriate permissions on remote .ssh directory and authorized_keys file.

7. Tests the SSH connection to confirm passwordless login works correctly using the newly exchanged keys.

The script automates what would otherwise be a manual multi-step process, allowing easy setup of SSH public key authentication. This improves security as passwords are not required to login once keys are set up.

It can be customized with different usernames, servers etc and incorporated into provisioning/configuration scripts to auto-deploy keys to multiple servers.
