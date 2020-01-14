.PHONY: clean all install

REV     := $(shell git rev-parse --short @{0})
STRIP   := strip
CFLAGS  := -std=c99 -pedantic -Wall -Wextra -DREV=\"$(REV)\"
TARGET  := petool

ifdef DEBUG
    CFLAGS  += -ggdb
else
    CFLAGS  += -O2
endif

COM := common.h cleanup.h
VPATH := src

all: $(TARGET)

$(TARGET): $(notdir $(subst .c,.o,$(wildcard src/*.c)))
	$(CC) $(CFLAGS) -o $@ $^
	$(STRIP) -s $@

common.o: $(COM)
main.o:   common.h

dump.o export.o genlds.o genmak.o genprj.o import.o patch.o pe2obj.o re2obj.o setdd.o setvs.o : pe.h $(COM)

clean:
	$(RM) $(TARGET) $(wildcard *.o)

install: $(TARGET)
	install -Dt $(DESTDIR)$(PREFIX)/bin/ $(TARGET)

uninstall: 
	$(RM) $(DESTDIR)$(PREFIX)/bin/$(TARGET)
