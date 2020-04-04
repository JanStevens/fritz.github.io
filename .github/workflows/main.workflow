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
