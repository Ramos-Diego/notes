# Node.js tips and tricks

### Log complete object in console (Node.js)

``` javascript
const { inspect } = require('util')

console.log(inspect(myObject, {depth: null, colors: true}))
```
[util.inspect docs.](https://nodejs.org/api/util.html#util_util_inspect_object_showhidden_depth_colors)

---