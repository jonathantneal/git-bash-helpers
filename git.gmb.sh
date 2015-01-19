#!/bin/bash
# gmb: merges another branch into the current branch

function gmb {
	# print usage if not repository or without argument
	(! git rev-parse --is-inside-work-tree > /dev/null 2>&1 || [ -z "$1" ]) && echo "Usage: gmb" && return

	# origin as argument, destination as current branch
	local FROM=$1
	local INTO=$(git symbolic-ref HEAD | sed 's/refs\/heads\///')

	# checkout and pull origin, checkout and pull destination, merge origin into destination
	git checkout $FROM && git pull origin $FROM && git checkout $INTO && git pull origin $INTO && git merge $FROM --no-edit --no-ff ${@:2}

	# push changes if destination has commits and user confirms
	if [ -n "$(git log --branches --not --remotes)" ] && echo -n "Push changes to '$INTO'? [y/n] " && read -q && echo; then
		git push origin $INTO
	fi
}

if [ "$ZSH_VERSION" ] ; then
	compdef _git gmb=git-merge
fi
