TARGET := libmini.so libmini.a start.o

C_FILES   := $(wildcard *.c)
ASM_FILES := $(wildcard *.asm)
ASM_FILES := $(filter-out start.asm, $(ASM_FILES))
O_FILES  = $(C_FILES:%.c=%_c.o)
O_FILES += $(ASM_FILES:%.asm=%_s.o)

all: $(TARGET)

libmini.so: $(O_FILES)
	ld -shared -o $@ $^

libmini.a: $(O_FILES)
	ar rcs $@ $^

start.o: start.asm
	yasm -f elf64 -DYASM -D__x86_64__ -DPIC $< -o $@

%_c.o: %.c
	gcc -c -g -Wall -fno-stack-protector -fPIC -nostdlib -masm=intel \
	    -I. $< -o $@

%_s.o: %.asm
	yasm -f elf64 -DYASM -D__x86_64__ -DPIC $< -o $@

.PHONY: clean
clean:
	rm -f $(O_FILES) $(TARGET)