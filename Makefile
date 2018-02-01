





CC=gcc



# Use $ xxd -i ./LICENSE > LICENSE.h
# to create the license info file. Should be signed char, add a
# null character to the end of the array.

# -O3 -g
# -std=gnu11
CFLAGS= -Wall -g -std=gnu11 -pedantic -DUNIX_HOST -DVER=\"`git show-ref --abbrev=8 --head --hash head`\" -DTAG=\"`git describe --abbrev=0 --tags`\"
LIBS=-lm -lreadline -lcsfml-graphics -lcsfml-window -lcsfml-system -lcsfml-audio

LIBS1=-lm -lreadline 

LIBSSFML=-lsfml-graphics -lsfml-window -lsfml-system -lcsfml-graphics -lcsfml-window -lcsfml-system -lcsfml-audio


SRCS_CPP = sfmltest.cpp

OBJS_CPP = sfmltest.o

TARGET	= picoc

TARGET1 = picocNoSFML

SRCS	= picoc.c table.c lex.c parse.c expression.c heap.c type.c \
	variable.c clibrary.c platform.c include.c debug.c \
	platform/platform_unix.c platform/library_unix.c \
	cstdlib/stdio.c cstdlib/math.c cstdlib/string.c cstdlib/stdlib.c \
	cstdlib/time.c cstdlib/errno.c cstdlib/ctype.c cstdlib/stdbool.c \
	cstdlib/unistd.c \
	tools.c \
	gui.c


OBJS	:= $(SRCS:%.c=%.o)

SRCS1 = $(filter-out gui.c, $(SRCS))

OBJS1	:= $(SRCS1:%.c=%.o)

all: $(TARGET)

noSFML: $(TARGET1)


$(TARGET): $(OBJS)  
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LIBS)

$(TARGET1): $(OBJS1)  
	$(CC) $(CFLAGS) -o $(TARGET1) $(OBJS1) $(LIBS1)

test:	all
	@(cd tests; make -s test)
	@(cd tests; make -s csmith)
	@(cd tests; make -s jpoirier)

clean:
	rm -f $(TARGET) $(OBJS) *~

	
count:
	@echo "Core:"
	@cat picoc.h interpreter.h picoc.c table.c lex.c parse.c expression.c platform.c heap.c type.c variable.c include.c debug.c | grep -v '^[ 	]*/\*' | grep -v '^[ 	]*$$' | wc
	@echo ""
	@echo "Everything:"
	@cat $(SRCS) *.h */*.h | wc

.PHONY: clibrary.c

gui.o: gui.c gui.h
tools.o: tools.c tools.h
picoc.o: picoc.c picoc.h
table.o: table.c interpreter.h platform.h
lex.o: lex.c interpreter.h platform.h
parse.o: parse.c picoc.h interpreter.h platform.h
expression.o: expression.c interpreter.h platform.h
heap.o: heap.c interpreter.h platform.h
type.o: type.c interpreter.h platform.h
variable.o: variable.c interpreter.h platform.h
clibrary.o: clibrary.c picoc.h interpreter.h platform.h
platform.o: platform.c picoc.h interpreter.h platform.h
include.o: include.c picoc.h interpreter.h platform.h
debug.o: debug.c interpreter.h platform.h
platform/platform_unix.o: platform/platform_unix.c picoc.h interpreter.h platform.h
platform/library_unix.o: platform/library_unix.c interpreter.h platform.h
cstdlib/stdio.o: cstdlib/stdio.c interpreter.h platform.h
cstdlib/math.o: cstdlib/math.c interpreter.h platform.h
cstdlib/string.o: cstdlib/string.c interpreter.h platform.h
cstdlib/stdlib.o: cstdlib/stdlib.c interpreter.h platform.h
cstdlib/time.o: cstdlib/time.c interpreter.h platform.h
cstdlib/errno.o: cstdlib/errno.c interpreter.h platform.h
cstdlib/ctype.o: cstdlib/ctype.c interpreter.h platform.h
cstdlib/stdbool.o: cstdlib/stdbool.c interpreter.h platform.h
cstdlib/unistd.o: cstdlib/unistd.c interpreter.h platform.h

