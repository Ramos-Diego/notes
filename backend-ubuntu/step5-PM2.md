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
│   └── test.html
└── app.js
```

Create sample static file (test.html)
```html
<!-- ~/node-app/public/test.hmtl -->
<h1>HELLO! NGINX is serving this static file (test.html)</h1>
```

This file will be available at `yourDomain.com/test.html`

Create simple test app
```javascript
// ~/node-app/app.js
const express = require('express')
const app = express()

// Send a message
app.get('/', (req, res) => res.send('Hello from the Node app running on localhost:8080'))

// Start listening on localhost:8080
app.listen(8080, 'localhost')
```
This message will be available at `yourDomain.com`

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