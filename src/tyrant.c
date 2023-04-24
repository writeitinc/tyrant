#include "tyrant.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

const int TYRANT_VERSION_MAJOR = TYRANT_API_VERSION_MAJOR;
const int TYRANT_VERSION_MINOR = TYRANT_API_VERSION_MINOR;
const int TYRANT_VERSION_PATCH = TYRANT_API_VERSION_PATCH;

const char TYRANT_VERSION_STRING[] = TYRANT_API_VERSION_STRING;

void *tyrant_alloc(size_t size)
{
	if (size == 0) {
		return NULL;
	}

	return malloc(size);
}

void *tyrant_calloc(size_t size, size_t len)
{
	if (size == 0 || len == 0
			|| SIZE_MAX / size < len) {
		return NULL;
	}

	return calloc(len, size);
}

void *tyrant_alloc_arr(size_t size, size_t len)
{
	if (size == 0 || SIZE_MAX / size < len) {
		return NULL;
	}

	return tyrant_alloc(size * len);
}

void *tyrant_realloc(void *ptr, size_t size, bool *ret_success)
{
	if (size == 0) {
		*ret_success = false;
		return ptr;
	}

	void *ptr_new = realloc(ptr, size);
	if (!ptr_new) {
		*ret_success = false;
		return ptr;
	}

	*ret_success = true;
	return ptr_new;
}

void *tyrant_realloc_arr(void *ptr, size_t size, size_t len, bool *ret_success)
{
	if (size == 0 || SIZE_MAX / size < len) {
		*ret_success = false;
		return ptr;
	}

	return tyrant_realloc(ptr, size * len, ret_success);
}

void tyrant_free(void *ptr)
{
	free(ptr);
}
