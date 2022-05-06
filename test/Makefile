TARGET := write1 alarm1 alarm2

all: $(TARGET)

start:
	yasm -f elf64 -DYASM -D__x86_64__ -DPIC $@.asm -o $@.o

write1: start
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o $<.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o $<.o -L. -L.. -lmini

alarm1: start
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o $<.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o $<.o -L. -L.. -lmini

alarm2: start
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o $<.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o $<.o -L. -L.. -lmini

.PHONY: clean
clean:
	rm -f *.o $(TARGET)