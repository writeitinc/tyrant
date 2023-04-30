NAME = tyrant

CFLAGS = $(WFLAGS) $(OPTIM)

WFLAGS = -Wall -Wextra -pedantic -std=c99

BUILD_DIR = build

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

SOURCES = $(wildcard src/*.c)
HEADERS = $(wildcard src/*.h)
STATIC_OBJS = $(patsubst src/%.c, $(STATIC_OBJ_DIR)/%.o, $(SOURCES))
SHARED_OBJS = $(patsubst src/%.c, $(SHARED_OBJ_DIR)/%.o, $(SOURCES))

RELRO_FLAGS = -Wl,-z,relro,-z,now

$(STATIC_LIB): $(STATIC_OBJS)
	$(AR) crs $@ $^

$(SHARED_LIB): $(SHARED_OBJS)
	$(CC) -shared $(RELRO_FLAGS) -o $@ $^

$(STATIC_OBJ_DIR)/%.o: src/%.c $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS) $(DEBUG) $(DEFINES)

$(SHARED_OBJ_DIR)/%.o: src/%.c $(HEADERS)
	$(CC) -c -fPIC -o $@ $< $(CFLAGS) $(DEBUG) $(DEFINES)

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

# clean

.PHONY: clean
clean:
	$(RM) -r build/*
