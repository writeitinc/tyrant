NAME = tyrant

CFLAGS = $(WFLAGS) $(OPTIM)

WFLAGS = -Wall -Wextra -pedantic -std=c99

WORKING_DIR = .
BUILD_DIR = build

SRC_DIR = $(WORKING_DIR)/src

INCLUDE_DIR = $(BUILD_DIR)/include
HEADER_DIR = $(INCLUDE_DIR)/$(NAME)

OBJ_DIR = $(BUILD_DIR)/obj
STATIC_OBJ_DIR = $(OBJ_DIR)/static
SHARED_OBJ_DIR = $(OBJ_DIR)/shared

LIB_DIR = $(BUILD_DIR)/lib

STATIC_LIB = $(LIB_DIR)/lib$(NAME).a
SHARED_LIB = $(LIB_DIR)/lib$(NAME).so
LIBRARIES = $(STATIC_LIB) $(SHARED_LIB)

.PHONY: default
default: release

.PHONY: release
release: OPTIM = -O3
release: dirs headers $(LIBRARIES)

.PHONY: debug
debug: DEBUG = -fsanitize=address,undefined
debug: OPTIM = -g
debug: dirs headers $(LIBRARIES)

# library

SOURCES = $(wildcard $(SRC_DIR)/*.c)
HEADERS = $(wildcard $(SRC_DIR)/*.h)
STATIC_OBJS = $(patsubst $(SRC_DIR)/%.c, $(STATIC_OBJ_DIR)/%.o, $(SOURCES))
SHARED_OBJS = $(patsubst $(SRC_DIR)/%.c, $(SHARED_OBJ_DIR)/%.o, $(SOURCES))

PIC_FLAGS = -fPIC

$(STATIC_LIB): $(STATIC_OBJS)
	$(AR) crs $@ $^

$(SHARED_LIB): $(SHARED_OBJS)
	$(CC) -o $@ $^ -shared $(PIC_FLAGS) $(LDFLAGS)

$(STATIC_OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	$(CC) -o $@ $< -c $(CFLAGS) $(DEBUG) $(DEFINES)

$(SHARED_OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	$(CC) -o $@ $< -c $(PIC_FLAGS) $(CFLAGS) $(DEBUG) $(DEFINES)

# headers

.PHONY: headers
headers: $(HEADER_DIR)

$(HEADER_DIR): $(HEADERS)
	mkdir -p $@
	cp -u $^ $@/
	touch $@

# dirs

.PHONY: dirs
dirs: $(STATIC_OBJ_DIR)/ $(SHARED_OBJ_DIR)/ $(LIB_DIR)/ $(INCLUDE_DIR)/

%/:
	mkdir -p $@

# install

VERSION = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
VERSION_MAJOR = 1
VERSION_MINOR = 3
VERSION_PATCH = 0

DEST_DIR = /

.PHONY: install-linuxx
install-linux:
	install -Dm755 "build/lib/libtyrant.so" '$(DEST_DIR)/usr/lib/libtyrant.so.$(VERSION)'
	ln -sn "libtyrant.so.$(VERSION)" "$(DEST_DIR)/usr/lib/libtyrant.so.$(VERSION_MAJOR)"
	ln -sn "libtyrant.so.$(VERSION_MAJOR)" "$(DEST_DIR)/usr/lib/libtyrant.so"
	
	install -Dm644 -t "$(DEST_DIR)/usr/lib/" "build/lib/libtyrant.a"
	install -Dm644 -t "$(DEST_DIR)/usr/include/tyrant/" "build/include/tyrant/tyrant.h"
	install -Dm644 -t "$(DEST_DIR)/usr/share/licenses/tyrant/" "LICENSE"
	install -Dm644 -t "$(DEST_DIR)/usr/share/doc/tyrant/" "README.md"

# clean

.PHONY: clean
clean:
	$(RM) -r build/*
