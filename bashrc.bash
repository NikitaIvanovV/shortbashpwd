
# Add shortbashpwd
SHORT_BASH_PWD_PS1="$PS1"
if [ -e FILE ]; then
	. FILE
	shortbashpwd-setup
fi
