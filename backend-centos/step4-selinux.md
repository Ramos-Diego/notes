
## SELinux

SELinux is a Linux kernel security module that provides a mechanism for supporting access control security policies. It is known to be complicated, but you don't need to know all the details to use it.

SELinux configuration [article](https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts), [video](https://www.youtube.com/watch?v=HhydNtaLEK0&list=PLQlWzK5tU-gDyxC1JTpyC2avvJlt3hrIh&index=9)

## Serve static files with Nginx and SELinux

You can server static files using Node.js, however Nginx performs this function much, much faster. To enable this while `enforcing` SELinux we do the following:

- Check that nginx can execute/cd into the static folder
- give nginx the permission to read the static folder
```sh
namei -om /absolute/path/to/static/folder
```
- `namei`: Follow a pathname until a terminal point is found.
- `-m`: show the mode bits of each file
- `-o`: show owner and group name of each file

Here is an example: 
```sh
# Output
namei -om /home/mike/myNginx/public/
f: /home/mike/myNginx/public/
 dr-xr-xr-x root root /
 drwxr-xr-x root root home
 drwx------ mike mike mike
 drwxrwxr-x mike mike myNginx
 drwxrwxr-x mike mike public
```

You must modify the permissions for the following directory: 
```sh
drwx------ mike mike mike
```

If the permissions on the absolute path do not allow nginx to reach the folder do this:

Change the group of problematic directory for
to nginx
```sh
chown [insert-user]:nginx /path/to/problematic/directory
```
`chown`: change file owner and group

Give the nginx group permission to execute
```sh
chmod g+x /path/to/problematic/directory
```
- `chmod`: change file mode bits
- `g`: group
- `+x`: add permission to execute

The fixed example outputs:
```sh
chown mike:nginx /home/mike
chmod g+x /home/mike/
namei -om /home/mike/myNginx/public/
f: /home/mike/myNginx/public/    
 dr-xr-xr-x root root  /
 drwxr-xr-x root root  home      
 drwx--x--- mike nginx mike      
 drwxrwxr-x mike mike  myNginx   
 drwxrwxr-x mike mike  public  

# Notice how mike's directory changed from
drwx------ mike mike mike
# to 
drwx--x--- mike nginx mike
```
---

Check if SELinux is installed and **enforced**
```sh
getenforce
```
or
```sh
sestatus
```

If SELinux is not `enforcing`, match this configuration

```sh
nano /etc/selinux/config
```

```sh
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

Reboot the server
```sh
reboot
```

Check if SELinux is `enforcing`
```sh
getenforce
```
---
Once SELinux is enforced we need to make changes to enable http requests to our server:

Allow HTTP servers to connect to other backends
```sh
setsebool -P httpd_can_network_connect on
```
- `-P`: persist change

Allow HTTP servers to read files from user home directory
```sh
setsebool -P httpd_enable_homedirs on
```

Change the context of the static folder and its files to be accessible. In other words, enable your static files to be served by **Nginx**.

```sh
chcon -Rt httpd_sys_content_t /path/to/static/folder
```
- `-R`: Recursive change
- `-t`: Change directory/file TYPE

from
<pre>
<code>
-rw-rw-r--. jeff jeff system_u:object_r:<mark><b>user_home_t</b></mark>:s0 index.html
</code>
</pre>
to
<pre>
-rw-rw-r--. jeff jeff system_u:object_r:<mark><b>httpd_sys_content_t</b></mark>:s0 index.html
</pre>

Check the context details for files and directories
```sh
ls -lZ /path/to/folder
```

Check context of current processes
```sh
ps auxZ | grep nginx
```

**SELinux debugging**

Set SELinux to `enforce` mode
```sh
setenforce 1
```

Set SELinux to `permissive` mode. This mode only logs the output from SELinux, thus it can be used to debug your setup. If you make SELinux `permissive` and your app works as it should, you need to check your policies.
```sh
setenforce 0
```

---
AppArmor is the Ubuntu equivalent to SELinux.
