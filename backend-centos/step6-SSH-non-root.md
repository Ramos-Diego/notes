From this point on, you will not modify the nginx configuration very often, but you may still want to regularly access your non-root user to update and mantain your applications. You may also grant access to your server to a third-party user which cannot run sudo commands.

1. Switch `root` to a non-root user
```sh
sudo su -l [insert-username]
```

Verify you're using the right user
```sh
whoami
```

2. Create `/.ssh` directory
```sh
mkdir ~/.ssh
```

3. Change `/.ssh`'s directory permissions
```sh
chmod 700 ~/.ssh
```
700: gives **r**ead, **w**rite and e**x**excute permission to the owner

`700 = - rwx --- ---`

4. Create the standard `authorized_keys` file to store your public keys
```sh
touch ~/.ssh/authorized_keys
```

5. Change keys permissions
```sh
chmod 600 ~/.ssh/authorized_keys
```
600: gives **r**ead, **w**rite and permission to the owner

`600 = - rw- --- ---`

Verify permissions
```sh
ls -lRa ~/. | egrep '.ssh|authorized_keys'
```

- `-l`: Verbose output
- `-R`: Recursive mode
- `-a`: All files 

6. Copy your public key `~/.ssh/id_rsa.pub` from your local machine and paste it in `authorized_keys` for the non-root user

```sh
nano ~/.ssh/authorized_keys
```

**All in one command**
```sh
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys
```

---

You can also use `ssh-copy-id` which performs all the previous commands, however you can only use it if the user has password authorization enabled.

```sh
ssh-copy-id -i ~/.ssh/mykey user@host
```