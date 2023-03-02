NAME = tyrant

CFLAGS = $(WFLAGS) $(OPTIM)

WFLAGS = -Wall -Wextra -pedantic -std=c99

BUILD_DIR = build

OBJ_DIR = $(BUILD_DIR)/obj
LIB_DIR = $(BUILD_DIR)/lib
INCLUDE_DIR = $(BUILD_DIR)/include
HEADER_DIR = $(INCLUDE_DIR)/$(NAME)

LIBRARIES = $(LIB_DIR)/lib$(NAME).a

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

LIB_SRCS = $(wildcard src/*.c)
LIB_OBJS = $(patsubst src/%.c, $(OBJ_DIR)/%.o, $(LIB_SRCS))
LIB_HEADERS = $(wildcard src/*.h)

$(LIB_DIR)/lib$(NAME).a: $(LIB_OBJS)
	$(AR) crs $@ $^

$(OBJ_DIR)/$(NAME).o: src/$(NAME).c $(LIB_HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS) $(DEBUG) $(DEFINES)

# headers

.PHONY: headers
headers: $(HEADER_DIR)

$(HEADER_DIR): $(LIB_HEADERS)
	mkdir -p $@
	cp -u $^ $@/
	touch $@

# dirs

.PHONY: dirs
dirs: $(OBJ_DIR)/ $(LIB_DIR)/ $(INCLUDE_DIR)/

%/:
	mkdir -p $@

# clean

.PHONY: clean
clean:
	$(RM) -r build/*
