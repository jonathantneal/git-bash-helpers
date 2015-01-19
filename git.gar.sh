#!/bin/bash
# gar: archives and tags the current branch

function gar {
	# print usage if not repository
	! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && echo "Usage: gar" && return

	# origin as current branch, destination as prefixed origin
	local FROM=$(git symbolic-ref HEAD | sed 's/refs\/heads\///')
	local INTO="archive/$FROM"

	# checkout and pull master, tag archive from origin, delete origin
	git checkout master && git pull origin master && git tag $INTO $FROM && git branch -d $FROM

	# push changes and delete origin if user confirms
	if echo -n "Push changes to '$INTO' and delete '$FROM'? [y/n] " && read -q && echo; then
		# push changes
		git push origin $INTO && git push origin --delete $FROM
	fi
}
