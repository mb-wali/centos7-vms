# SSH

## OpenSSH
OpenSSH is a suite of secure networking utilities based on the Secure Shell protocol, which provides a secure channel over an unsecured network in a client–server architecture.

### Setup SSH for servers and ansible controller
All these key generation is done on ansible controller machine, or your private computer.

**(Note)**: Initial connection prompt, ansible can automaticly accept the initial prompt.
to skip this manully we can run this command `ssh-keyscan -H 127.1.1.2` and past the result for each server on a file called `known_hosts`.


**list .ssh folder**
```bash
ls -la .ssh
```

**Generate ssh-key**
```bash
ssh-keygen -t ed25519 -C "key comment here"
```
* `-t` type, ed25519 - this type is more secure, and its a shorter key.
* `-C` comment almost like a metadata for the key.


### Using this ssh-key to connet to other servers
For this we need to copy the public key to our servers.

**Copy the key to servers.**
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub <serveripaddress e.g. 172.1.12.12>
```
* `-i` stands for input file.
The command will copy the public key to the server under `~/.ssh/authorized-keys` file. 


### Generate ssh key that is only dedicated to only ansible
```bash
ssh-keygen -t ed25519 -C "ansible"
```
**caution**: not to override the previous one, we should specify a different path or folder for this ssh.
we should copy these public key as well to our servers.

### Access the Servers with ssh using different keys
```bash
ssh -i ~/.ssh/ansible 172.1.12.12
```
This time we specify the key folder in our ssh command to access the server.


### Cache the passphrase of ssh-key, so it not ask for it everytime
```bash
eval $(ssh-agent)
```
`ssh-agent` a proccess that can run in the background and cache the passphrase.

Then we can add the ssh.
```bash
ssh-add
```
this will ask you for the passphrase.
**Note**: this is not permanent, as soon the terminal is closed the agent is stoped.
