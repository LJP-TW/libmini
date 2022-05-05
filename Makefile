TARGET := libmini.so libmini.a

C_FILES   = $(wildcard *.c)
ASM_FILES = $(wildcard *.asm)
O_FILES  = $(C_FILES:%.c=%_c.o)
O_FILES += $(ASM_FILES:%.asm=%_s.o)

all: $(TARGET)

libmini.so: $(O_FILES)
	ld -shared -o $@ $^

libmini.a: $(O_FILES)
	ar rcs $@ $^

%_c.o: %.c
	gcc -c -g -Wall -fno-stack-protector -fPIC -nostdlib -masm=intel \
	    -I. $< -o $@

%_s.o: %.asm
	yasm -f elf64 -DYASM -D__x86_64__ -DPIC $< -o $@

.PHONY: clean
clean:
	rm -f $(O_FILES) $(TARGET)