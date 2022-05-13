TARGET := write1 alarm1 alarm2 alarm3 jmp1

all: $(TARGET)

write1:
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o ../start.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o ../start.o -L. -L.. -lmini

alarm1:
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o ../start.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o ../start.o -L. -L.. -lmini

alarm2:
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o ../start.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o ../start.o -L. -L.. -lmini

alarm3:
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o ../start.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o ../start.o -L. -L.. -lmini

jmp1:
	gcc -c -g -Wall -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI $@.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ $@.o ../start.o -L. -L.. -lmini
	ld -m elf_x86_64 -static -o $@_static $@.o ../start.o -L. -L.. -lmini

.PHONY: clean
clean:
	rm -f *.o $(TARGET)