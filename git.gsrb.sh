#!/bin/bash
# gsrb: rebases the svn branch

function gsrb {
	# print usage if not repository
	! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && echo "Usage: gsrb" && return

	# origin as current branch
	local FROM=$(git symbolic-ref HEAD | sed 's/refs\/heads\///')

	# checkout and rebase svn
	git checkout svn && git svn rebase

	# checkout and pull master, merge svn into master - if user confirms
	if echo -n "Merge 'svn' into 'master'? [y/n] " && read -q && echo; then
		git checkout master && git pull origin master && git merge svn --no-edit --no-ff ${@:1}

		# push changes if master has commits and user confirms
		if [ -n "$(git log --branches --not --remotes)" ] && echo -n "Push changes to 'master'? [y/n] " && read -q && echo; then
			git push origin master
		fi
	fi

	# checkout origin
	git checkout $FROM
}
