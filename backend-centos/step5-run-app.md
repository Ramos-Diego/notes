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
example.com
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
app.get('/', (req, res) => res.send('<h1>Hello from the Node app running on localhost:8080</h1>'))

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
pm2 start app.js --name example.com 
```
Go to your domain and test the app.

Save the current pm2 configuration to be initiated on reboot

```sh
pm2 save
```

Get the script need to enable PM2 to startup on boot
```sh
pm2 startup
```
Copy and paste the command provided by PM2.

```
[PM2] Init System found: systemd
user
[PM2] To setup the Startup Script, copy/paste the following command:
sudo env PATH=$PATH:/usr/bin /usr/local/share/.config/yarn/global/node_modules/pm2/bin/pm2 startup systemd -u user --hp /home/user
```

Test by restart the server

As `root`
```sh
reboot
```