#!/bin/sh

commit() {
	if [ -z "$(git status -s -uno | grep -v '^ ' | awk '{print $2}')" ]; then
		gum confirm "Stage all?" && git add . || return
	fi	

	TYPE=$(gum choose "BUGFIX" "FEAT" "DOCS" "STYLE" "REFACTOR" "TEST" "DEPS" "REVERT" "CHORE" "DATA" --header "Commit Type")
	SCOPE=$(gum input --placeholder "Commit Scope")

	# Since the scope is optional, wrap it in parentheses if it has a value.
	test -n "$SCOPE" && SCOPE="($SCOPE) "

	# Pre-populate the input with the type(scope): so that the user may change it
	SUMMARY=$(gum input --value "$TYPE $SCOPE" --placeholder "Summary of this change")

	FILES=$(git status -s -uno)

	echo -e "{{ Bold \"Files \" }} $(echo $FILES)" | gum format -t template 
	printf '\n'
	echo -e "{{ Bold \"Message \" }} $(echo $SUMMARY)" | gum format -t template
	printf '\n'
	read -p "Press Enter to continue…"

	# Commit these changes if user confirms
	gum confirm "Commit changes?" --default=false && git commit -m "$SUMMARY" || return
	gum confirm "Push changes?" --default=true && git push
}
