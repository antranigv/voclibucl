.POSIX:

export CFLAGS=-I /usr/local/include/ -L /usr/local/lib -lucl
#export LDFLAGS="-L /usr/local/lib -lucl"
#export CFLAGS="-I /usr/local/include/"

build:
	@if [ ! -d build ]; then \
		mkdir build; \
	fi
	@cd build; voc -rs ../src/ucl.Mod

test: build
	@cd build; cp -v ../test/example.ucl .
	@cd build; voc ../test/libucl_test.Mod -m
	@cd build; ./libuclTest

clean:
	rm -rf build
