# [fritz.ninja](https://fritz.ninja) · ![ninja](/static/img/ninja.png) · ![badge](https://action-badges.now.sh/JanStevens/fritz.github.io)

Hello :wave:, welcome to my [personal website](https://fritz.ninja) soure code!

This website runs on Github and uses a free cloudflare account (for SSL and caching) in front of it. Using Hugo a statical HTML version is created from this source code (visible in the gh-pages branch).

When I push something to the master branch, GitHub Action compiles the static HTML and commits it to the gh-pages branch. This workflow is almost identical to the one described [here](https://github.com/peaceiris/actions-hugo) but I had to add a new action in front of it. 

Apparently git submodules are not pulled so my first attempt tried to use an existing [action](https://github.com/chris-short/github-action-git-submodules), didn't work out well. So I ended up using a more generic git actions where I could easly cd into the theme directory and clone the hugo coder repository. Added bonus is that this also keeps my website on the latest version of the coder theme.

The full [workflow](.github/main.workflow)

```hcl
workflow "GitHub Pages" {
  on = "push"
  resolves = ["deploy"]
}

action "checkout-theme" {
  uses = "srt32/git-actions@master"
  args = "cd themes && git clone https://github.com/luizdepra/hugo-coder.git"
}

action "is-branch-master" {
  needs = "checkout-theme"
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "is-not-branch-deleted" {
  needs = "checkout-theme"
  uses = "actions/bin/filter@master"
  args = "not deleted"
}

action "build" {
  needs = ["is-branch-master", "is-not-branch-deleted"]
  uses = "peaceiris/actions-hugo@v0.55.6"
  args = ["--gc", "--minify", "--cleanDestinationDir"]
}

action "deploy" {
  needs = "build"
  uses = "peaceiris/actions-gh-pages@v1.0.1"
  env = {
    PUBLISH_DIR = "./public"
    PUBLISH_BRANCH = "gh-pages"
  }
  secrets = ["ACTIONS_DEPLOY_KEY"]
}

workflow "New workflow" {
  on = "push"
}
```

## Credits

This website wouldn't be possible without the following projects:

- Hugo (https://github.com/gohugoio/hugo)
- Hugo Coder (https://github.com/luizdepra/hugo-coder)
- Git Actions (https://github.com/srt32/git-actions)
- Hugo Actions (https://github.com/peaceiris/actions-hugo)
- Github Pages Actions (https://github.com/peaceiris/actions-gh-pages)
