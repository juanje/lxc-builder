prefix = /usr/local
bindir = $(prefix)/bin

SCRIPTS = bin/*

install:
	install -d -m 0755 $(DESTDIR)$(bindir)
	install -m 0755 $(SCRIPTS) $(DESTDIR)$(bindir)

