# Properly format $PWD
_shortbashpwd_fmt() {
	printf '%s\n' "$PWD" |
		sed -e "s,^/home/$USER\(/\|$\),~/," -e ':a; s|/\(\.\?[^.]\)[^/]\+/|/\1/|; ta'
}

# Update PS1 when a directory is changed
# The second condition allows a user to change PS1 on command line
shortbashpwd() {
	if [ -z "$1" ] || [ "$PWD" != "$_shortbashpwd_oldpwd" -a "$PS1" == "$_shortbashpwd_ps1" ]; then
		PS1="${SHORT_BASH_PWD_PS1//\\[Ww]/$(_shortbashpwd_fmt)}"
		_shortbashpwd_oldpwd="$PWD"
		_shortbashpwd_ps1="$PS1"
	fi
}

# Setup prompt command
shortbashpwd-setup() {
	[ -z "$SHORT_BASH_PWD_PS1" ] &&
		echo 'shortbashpwd: $SHORT_BASH_PWD_PS1 is not set' >&2 &&
		return

	[[ ! "$SHORT_BASH_PWD_PS1" =~ \\[Ww] ]] &&
		echo 'shortbashpwd: $SHORT_BASH_PWD_PS1 does not contain placeholder \w' >&2 &&
		return

	shortbashpwd
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }shortbashpwd 1"
}
