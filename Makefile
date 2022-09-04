PREFIX     = /usr/local
DATAPREFIX = $(DESTDIR)$(PREFIX)/share/shortbashpwd

BASHRC = ~/.bashrc

MKDIR        = mkdir -p
INSTALL      = install
INSTALL_DATA = $(INSTALL) -m0664

all:

install:
	$(MKDIR) $(DATAPREFIX)
	$(INSTALL_DATA) shortbashpwd.bash $(DATAPREFIX)
	@echo; echo "Run 'make bashrc' or refer to documentation to complete installation"

uninstall:
	$(RM) $(DATAPREFIX)/shortbashpwd.bash

bashrc:
	grep -q '\<shortbashpwd-setup\>' $(BASHRC) || \
		sed 's|FILE|$(DATAPREFIX)/shortbashpwd.bash|' bashrc.bash >> $(BASHRC)

.PHONY: all install uninstall bashrc
