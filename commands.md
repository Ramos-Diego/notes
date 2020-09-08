# The bash commands they don't want you to know!

If you're having issues with `localhost` note resolving on Windows 10 WSL 2 run this on CMD

```sh
wsl --shutdown
```

Try again.

### Remove directory

``` sh
$ rm -rvf /path/to/directory
```

- `-r` = remove directories and their contents 
- `-v` = explain what is being done
-  `f` = ignore nonexistent files, never prompt

---
### Only display working directory in Bash

``` sh
$ echo "PS1='\W\\$ '" >> ~/.bashrc 
```
Appends `PS1='\W\$ '` to *.bashrc*

Relaunch terminal to see effect.

From:

``` sh
jeff@computer:~/very/long/path/to/directory$
```
to:
``` sh
directory$
```
more [PS1 options](http://bashrcgenerator.com/ ".bashrc Generator").

---
### Output working directory

``` sh
$ pwd
# OUTPUT:
home/jeff/long/path/to/directory
```
---
