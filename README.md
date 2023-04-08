# voclibucl

This library is a [`libucl`](https://github.com/vstakhov/libucl/) wrapper for [Vishap Oberon Compiler](https://github.com/vishaps/voc).

## Installation

This library has been tested on [FreeBSD](https://FreeBSD.org) running `voc v2.1.2` from Ports/Packages.

You ***do*** need `libucl` from Ports/Packages.

### Using git

1. Clone this repository
2. run `make`
3. You should have the symbol file at `build/ucl.sym`
4. You may use the source at `src/ucl.Mod`
5. You may run `build/libuclTest` to see some tests.

Technically, this library should be used with [`vipack`](https://github.com/vishaps/vipack), but who has the time eh :)

## Screenshot

![](http://notes.bsd.am/images/screenshot-2023-04-08-at-6.46.14-pm.png)