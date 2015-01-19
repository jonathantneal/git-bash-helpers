#!/bin/bash
# gm2: merges the current branch into another branch

function gm2 {
	# print usage if not in repository or without argument
	(! git rev-parse --is-inside-work-tree > /dev/null 2>&1 || [ -z "$1" ]) && echo "Usage: gm2 [branch]" && return

	# origin as current branch, destination as first argument, options as additional arguments (swamping "mine" and "theirs")
	local FROM=$(git symbolic-ref HEAD | sed 's/refs\/heads\///')
	local INTO=$1
	local OPTS=$(echo "${@:2}" | sed 's/ mine\b/ @!theirs/g' | sed 's/ theirs\b/ @!mine/g' | sed 's/ @!/ /g')

	# if origin pull and destination checkout are a success
	if git pull origin $FROM && git checkout $INTO; then
		# if merging into the svn branch
		if [ $INTO = 'svn' ]; then
			# if rebase of svn and merge of origin into destination are a success
			if git svn rebase && git merge $FROM --no-ff $OPTS; then
				# if destination has commits and user confirms commit
				if [ -n "$(git log --branches --not --remotes)" ] && echo -n "Commit changes to svn repository? [y/n] " && read -q && echo; then
					# if commit to svn repository is a success
					if git svn dcommit; then
						# if user confirms merge
						if echo -n "Merge 'svn' into 'master'? [y/n] " && read -q && echo; then
							# if checkout and pull of master and merge of svn into master is a success
							if git checkout master && git pull origin master && git merge svn --no-edit --no-ff; then
								# if master has commits and user confirms push
								if [ -n "$(git log --branches --not --remotes)" ] && echo -n "Push changes to 'master'? [y/n] " && read -q && echo; then
									# push changes to master
									git push origin master
								fi
							# if merge failed
							else return 1; fi
						fi
					# if commit failed
					else return 1; fi
				fi
			# if merge failed
			else return 1; fi

		# if merging into another branch than svn
		else
			# if destination pull and merge of origin into destination is a success
			if git pull origin $INTO && git merge $FROM --no-edit --no-ff $OPTS; then
				# if destination has commits and user confirms push
				if [ -n "$(git log --branches --not --remotes)" ] && echo -n "Push changes to '$INTO'? [y/n] " && read -q && echo; then
					# push changes to destination
					git push origin $INTO
				fi
			# if merge failed
			else return 1; fi
		fi

		# return to origin
		git checkout $FROM

	# if pull failed
	else return 1; fi
}

if [ "$ZSH_VERSION" ] ; then
	compdef _git gm2=git-merge
fi
