My dotfiles
-----------

These are config files to set up a system the way I like it.

## Installation

```
git clone git@github.com:aboltart/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
rake install
```

Install [Homebrew](https://github.com/Homebrew/homebrew) and [Brew Bundle](https://github.com/Homebrew/homebrew-bundle)

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap Homebrew/bundle
```

Install System Packages and Applications

```
brew bundle ~/.dotfiles/Brewfile
```

[Configure git](http://help.github.com/git-email-settings/)

```bash
git config --global user.name "your-name"
git config --global user.email "your-email"
```
