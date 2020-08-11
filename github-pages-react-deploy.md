## Deploy a React application using GitHub Pages

This tutorial asumes that you already have a working React application in development stored in a public GitHub repository.

1. Buy a domain. For exmaple, I use NameCheap.com to buy cheap .xyz domains.

2. Setup DNS for your domain:

| Type       | Host | Value           |
|------------|------|-----------------|
| A Record   |   @  | 185.199.108.153 |
| A Record   |   @  | 185.199.109.153 |
| A Record   |   @  | 185.199.110.153 |
| A Record   |   @  | 185.199.111.153 |

If unsure about this step, search **how to add A Records** in the DNS platform you have chosen.

These are the default IPs for [GitHub Pages](https://docs.github.com/en/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain).

3. Create a `CNAME` file in the root directory of your React app and enter you domain:

```sh
example.com
```

Note: `www.example.com` is a subdomain of `example.com`. This tutorial does not cover subdomains.

4. Edit your `package.json` file and add the following scripts

```json
"scripts": {
  ...
  "predeploy": "yarn build && cp CNAME ./build/",
  "deploy": "gh-pages -d build"
  }
```

The `predeploy` stage creates the build for you app and copies the CNAME file into build's root directory.

The deploy stage pushes the contents of the build directory to the `gh-pages` branch of your repository. If such branch doesn't exist, it will create it.

5. Install `gh-pages` as a dev dependency for your React app

```sh
yarn add gh-pages --dev
```

6. Deploy the React app to `gh-pages`

```
yarn deploy
```

7. Set the source branch for you GitHub Pages

Go to github.com/{your-github-username}/{your-react-depository}/settings

Scroll to Gihub Pages > set the source branch to `gh-pages`

8. Go to your example.com and dance!