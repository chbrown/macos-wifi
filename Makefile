# Set up overridable defaults (per recommendations: https://bit.ly/MakeDirectories)
INSTALL ?= install
prefix ?= /usr/local
bindir ?= $(prefix)/bin
# -O => Compile with optimizations
CFLAGS := -O

all: bin/wifi

bin/wifi: $(wildcard *.swift)
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc -target x86_64-apple-macosx10.10 $+ $(CFLAGS) -o $@

# -b => rename the replaced target `file` to `file.old` if it exists
# -v => show what's being installed
install: bin/wifi
	$(INSTALL) -b -v $< $(DESTDIR)$(bindir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/wifi

# -v => show what's being linked
# -t => specify target directory
link: bin/wifi
	stow -vt $(DESTDIR)$(bindir) bin

clean:
	rm -f bin/wifi

test:
	swiftformat --lint *.swift
	swiftlint lint *.swift
