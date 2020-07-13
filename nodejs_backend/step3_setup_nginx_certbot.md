## Configure non-root user

Become root
```sh
sudo su
```

Add an user
```sh
adduser <insert-username>
```

Add user to the `docker` group to use docker without `sudo`
```sh
usermod -aG docker <insert-username>
```

Switch to the new user
```sh
sudo su -l <insert-username>
```
- `-, -l, --login`: make the shell a login shell

Verify you're using the right user
```sh
whoami
```
