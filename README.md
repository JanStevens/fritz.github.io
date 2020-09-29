# <a href="https://fritz.ninja">fritz.![ninja](/static/img/ninja.png)</a> · ![badge](https://action-badges.now.sh/JanStevens/fritz.github.io)

Hello :wave:, welcome to my [personal website](https://fritz.ninja) soure code!

This website runs on Github and uses a free cloudflare account (for SSL and caching) in front of it. Using Hugo a statical HTML version is created from this source code (visible in the gh-pages branch).

When I push something to the master branch, GitHub Action compiles the static HTML and commits it to the gh-pages branch. This workflow is almost identical to the one described [here](https://github.com/peaceiris/actions-hugo) but I had to add a new action in front of it. 

Apparently git submodules are not pulled so my first attempt tried to use an existing [action](https://github.com/chris-short/github-action-git-submodules), didn't work out well. So I ended up using a more generic git actions where I could easily cd into the theme directory and clone the hugo coder repository. Added bonus is that this also keeps my website on the latest version of the coder theme. **Update** github actions now uses yaml files
which greatly improve and reduce the complexity, the updated and simplified version:

The full [workflow](.github/main.workflow)

```yaml
name: github pages

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.62.2'
          extended: true

      - name: Build
        run: hugo --minify --gc --cleanDestinationDir

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

## Credits

This website wouldn't be possible without the following projects:

- Hugo (https://github.com/gohugoio/hugo)
- Hugo Coder (https://github.com/luizdepra/hugo-coder)
- Git Actions (https://github.com/srt32/git-actions)
- Hugo Actions (https://github.com/peaceiris/actions-hugo)
- Github Pages Actions (https://github.com/peaceiris/actions-gh-pages)
