OBJS := main.o
APP := app

CFLAGS := -O2 -Wall -Werror -static -fPIE -fstack-protector-all -D_FORTIFY_SOURCE=2
LDFLAGS := -Wl,-z,now -Wl,-z,relro

.DEFAULT_GOAL := $(APP)

.PHONY: release
release: 
	$(MAKE) $(MAKEFILE) DEBUG="-s" 

.PHONY: debug
debug:
	$(MAKE) $(MAKEFILE) DEBUG="-g -DDEBUG"

.PHONY: symbols
symbols:
	$(MAKE) $(MAKEFILE) DEBUG="-g -fomit-frame-pointer"
	objcopy --only-keep-debug $(APP) $(APP).dbg
	objcopy --strip-debug $(APP)
	objcopy --add-gnu-debuglink=$(APP).dbg $(APP)
	strip -v -s $(APP)

.PHONY: clean
clean:
	rm -rf *.o $(APP) *.dbg

$(APP): $(OBJS)
	$(CC) $(CFLAGS) $(DEBUG) -o $@ $< $(LDFLAGS)

$(OBJS): %.o : %.c
	$(CC) $(CFLAGS) $(DEBUG) -o $@ -c $^
