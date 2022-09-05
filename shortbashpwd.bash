# Properly format $PWD
_shortbashpwd_fmt() {
	local pwd="$PWD"

	# Replace $HOME with ~
	local reg="^$HOME"'(/|$)'
	if [[ $pwd =~ $reg ]]; then
		pwd="${pwd:${#HOME}}"
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
# The third condition allows a user to change PS1 on command line
shortbashpwd() {
	if [[ -z $1 || ( "$PWD" != "$_shortbashpwd_oldpwd" && "$PS1" == '\[\e\]'* ) ]]; then
		_shortbashpwd_fmt
		PS1="\[\e\]${SHORT_BASH_PWD_PS1//\\[Ww]/$_shortbashpwd_pwd}"
		_shortbashpwd_oldpwd="$PWD"
	fi
}

# Setup prompt command
shortbashpwd-setup() {
	[[ -z $SHORT_BASH_PWD_PS1 ]] &&
		echo 'shortbashpwd: $SHORT_BASH_PWD_PS1 is not set' >&2 &&
		return

	[[ ! $SHORT_BASH_PWD_PS1 =~ \\[Ww] ]] &&
		echo 'shortbashpwd: $SHORT_BASH_PWD_PS1 does not contain placeholder \w' >&2 &&
		return

	shortbashpwd
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }shortbashpwd 1"
}
