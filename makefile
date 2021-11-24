asm_files := $(wildcard src/*.asm)
output := $(foreach wrd,$(basename $(notdir $(asm_files))),build/$(wrd))

build/%.o: src/%.asm
	mkdir -p build
	nasm -f elf64 $? -o $@

build/%: build/%.o
	ld -o $@ $?

all: $(output)

clean:
	rm -f *.o
	rm -f build/*


.PHONY : all clean
