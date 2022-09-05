# Properly format $PWD
_shortbashpwd_fmt() {
	local pwd="$PWD"
	local home="/home/$USER"

	# Replace /home/$USER with ~
	local reg="^$home"'(/|$)'
	if [[ $pwd =~ $reg ]]; then
		pwd="${pwd:${#home}}"
		pwd="~${pwd}"
	fi

	# Split directories and store in arr
	local -a arr
	IFS='/' read -r -a arr <<< "$pwd"

	# Abbreviate names
	for ((i=1;i<${#arr[@]}-1;i++)); do
		local c=1
		[[ ${arr[i]} == .* ]] && ((c++))
		arr[i]="${arr[i]:0:c}"
	done

	# Join elements of arr
	printf -v _shortbashpwd_pwd '/%s' "${arr[@]}"
	[[ $_shortbashpwd_pwd =~ ^//?$ ]] ||
		_shortbashpwd_pwd="${_shortbashpwd_pwd:1}"
}

# Update PS1 when a directory is changed
# The second condition allows a user to change PS1 on command line
shortbashpwd() {
	if [ -z "$1" ] || [ "$PWD" != "$_shortbashpwd_oldpwd" -a "$PS1" == "$_shortbashpwd_ps1" ]; then
		_shortbashpwd_fmt
		PS1="${SHORT_BASH_PWD_PS1//\\[Ww]/$_shortbashpwd_pwd}"
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
