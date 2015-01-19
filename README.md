# Git Bash Helpers

I wanted to share some git bash scripts I use to manage Git SVN projects. This is especially helpful for me when managing Git repos that push to [VIP](http://vip.wordpress.com/) websites.

## Installation

Clone this repository into a directory where the scripts may be sourced.

```sh
git clone https://github.com/jonathantneal/git-bash-helpers.git

echo 'source ~/git-bash-helpers/gar.sh' >> ~/.bash_profile
echo 'source ~/git-bash-helpers/gm2.sh' >> ~/.bash_profile
echo 'source ~/git-bash-helpers/gmb.sh' >> ~/.bash_profile
echo 'source ~/git-bash-helpers/gsrb.sh' >> ~/.bash_profile
```

## Commands

### gar

`gar` archives and tags the current branch.

```sh
git checkout fix/some-issue # checkout fix/some-issue
gar # tag fix/some-issue as archive/fix/some-issue
```

`gar` copies the current branch into a new branch prefixed with `archive/`, tagging the archived branch and removing the original. It then gives you the option to push these changes back to your remote.

### gm2

`gm2` merges the current branch into another branch without executing a fast-forward.

```sh
git checkout feature/some-detail # checkout feature/some-detail branch
gm2 develop # merge feature/some-detail branch into develop branch
```

`gm2` also gives you the option to push those changes back to your origin. If you’re merging to the svn branch, it gives you the option to commit those changes to your svn repository and then to push those changes back to remote master. 

The most common points of failure — failed pulls or merges — result in a halt of the script, making error and conflict resolution faster and easier.

### gmb

`gmb` merges another branch into the current branch without executing a fast-forward.

```sh
git checkout develop # checkout develop branch
gmb feature/some-detail # merge feature/some-detail branch into develop branch
```

`gmb` is the most redundant of all the helper commands, since it closely resembles `git merge`. The most helpful aspect of this command is the option to automatically push the merge to the remote branch.

### gsrb

`gsrb` rebases the svn branch.

```sh
git checkout feature/some-detail # checkout feature/some-detail branch
gsrb # rebase svn branch and merge changes to master without changing branches
```

Not everybody remembers to keep master in sync with svn, so `gsrb` just helps me keep things up to date without distracting myself with rebases and merges.
