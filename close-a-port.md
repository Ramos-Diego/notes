Figure out why `[rpcbind](https://www.digitalocean.com/community/questions/is-it-safe-to-remove-rpcbind)` opens port 111 by default and how to prevent it from starting because it a security risk.

| Proto  | Local Address | Foreign Address | State  | PID/Program name |
|--------|---------------|-----------------|--------|------------------|
| tcp    | 0 0.0.0.0:111 | 0.0.0.0:*       | LISTEN | 2677/rpcbind     |

SOLUTION

```sh
# Find the process ID (PID) for the open ports
netstat -tlnp

# Find the service name
systemctl status [PID]

# Stop process
systemctl stop [service name]

# Prevent from restarting on boot
systemctl disable [service name]

# Example
systemctl stop postfix.service

systemctl disable postfix.service
# Outputs
Removed symlink /etc/systemd/system/multi-user.target.wants/postfix.service.
```