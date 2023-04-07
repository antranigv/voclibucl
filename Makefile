.POSIX:

export CFLAGS=-I /usr/local/include/ -L /usr/local/lib -lucl
#export LDFLAGS="-L /usr/local/lib -lucl"
#export CFLAGS="-I /usr/local/include/"

all:
	@if [ ! -d build ]; then \
		mkdir build; \
	fi
	@cd build; voc -rs ../src/ucl.Mod ../test/libucl_test.Mod -m
