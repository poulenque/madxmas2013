MAKEFLAGS += --no-builtin-rules

.PHONY: all binary distclean clean run
.SUFFIXES:

all: madxmas2013.love
binary: madxmas2013

run: madxmas2013
	./madxmas2013
distclean: clean clean-love
clean:
	rm -f madxmas2013.love madxmas2013

madxmas2013: love madxmas2013.love
	cat $^ > $@
	chmod +x $@

madxmas2013.love: $(shell find src -print) $(shell find graphics -print)
	rm -f $@
	cd src && zip -rX9 ../$@ .
	zip -rX9 $@ graphics
	zip -rX9 $@ music

love: love-0.9.0/src/love
	cp $< $@

love-0.9.0/src/love: love-0.9.0
	( \
	  cd love-0.9.0; \
	  ./configure --disable-shared; \
	  make -j6; \
	)

love-0.9.0: love-0.9.0-linux-src.tar.gz
	tar -xzf $<

love-0.9.0-linux-src.tar.gz:
	wget "https://bitbucket.org/rude/love/downloads/love-0.9.0-linux-src.tar.gz" -O $@

clean-love:
	rm -f love
	rm -rf love-0.9.0
	rm -f love-0.9.0-linux-src.tar.gz

optipng:
	du -hs graphics
	find graphics -iname '*.png' -print0 | xargs -0 -n1 -P6 -t optipng -o7 -quiet
	du -hs graphics
