# x86_64

this is a collection of various programs i've written in x86-64

## directory structure

- `src/` stores x86-64 source files
- `build/` is where object and ELF files will be generated

## building / running

the makefile `makefile` is setup to build the `src/*.asm` files. the ELF executables
are outputed to `build/`.

```
$ # just build the fibonacci generation program
$ make build/fib

$ # build everything
$ make all

$ # run the fibonacci generation program
$ ./build/fib
How many fib values? 5
1
1
2
3
5
```

## license

  MIT License

  Copyright (c) 2021 Luke Spademan

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
