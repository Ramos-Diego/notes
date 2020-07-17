Add an user
```sh
adduser [insert-username]
```

Switch to the new user
```sh
su -l [insert-username]
```
- `-, -l, --login`: make the shell a login shell

Verify you're using the right user
```sh
whoami
```
---

Run app using PM2

Create the following folder structure in the home directory
```
node-app
├── public
│   └── index.html
└── app.js
```

Create simple test app
```javascript
// ~/node-app/app.js
const express = require('express')
const app = express()

// Send a message
app.get('/', (req, res) => res.send('This massage was went from the node app.'))

// Start listening on localhost:8080
app.listen(8080, 'localhost')
```

Install dependencies
```sh
cd ~/node-app/
```

```sh
yarn add express
```

Start the app using PM2
```sh
pm2 start app.js
```
Go to your domain and test the app.

Persist PM2 upon restart
```sh
pm2 startup
```
Copy and paste the command provided by PM2.
---

```
[PM2] Remove init script via:
$ pm2 unstartup systemd
root@Ubuntu-18:~# su -l jeff
```