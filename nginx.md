## Serve static files with Nginx

You can server static files using Node.js, however Nginx performs this function much, much faster. 

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
chowm user:nginx /path/to/folder
```
`chown`: change file owner and group

Give the nginx group permission to execute
```sh
chmod g+x /path/to/static/folder
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
drwx------ mike nginx mike
# to 
drwx--x--- mike nginx mike
```