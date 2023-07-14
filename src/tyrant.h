#ifndef tyrant_h
#define tyrant_h

#include <stddef.h>
#include <stdbool.h>

#define TYRANT_ALLOC_ARR(ptr, len) \
	tyrant_alloc_arr(sizeof((ptr)[0]), (len))

#define TYRANT_REALLOC_ARR(ptr, len, ret_success) \
	tyrant_realloc_arr((ptr), sizeof((ptr)[0]), (len), (ret_success))

#define TYRANT_NELEMS(arr) (sizeof(arr) / sizeof((arr)[0]))

/**
 * API (compile-time) and library (runtime) semantic versions
 *
 * The Semantic Versioning spec can be found at [https://semver.org/]
 */
#define TYRANT_API_VERSION_MAJOR 1
#define TYRANT_API_VERSION_MINOR 3
#define TYRANT_API_VERSION_PATCH 0
#define TYRANT_API_VERSION_STRING TYRANT__CONSTRUCT_VERSION_STRING( \
		TYRANT_API_VERSION_MAJOR, \
		TYRANT_API_VERSION_MINOR, \
		TYRANT_API_VERSION_PATCH)

extern const int TYRANT_VERSION_MAJOR;
extern const int TYRANT_VERSION_MINOR;
extern const int TYRANT_VERSION_PATCH;
extern const char TYRANT_VERSION_STRING[];

/**
 * Allocates `size` bytes of uninitialized memory
 *
 * On success:
 * - returns the address of the allocation
 * On failure:
 * - returns `NULL`
 *
 * Fails if:
 * - allocation fails
 * - `size` is 0
 */
void *tyrant_alloc(size_t size);

/**
 * Allocates `size` zero-initialized bytes of memory
 *
 * On success:
 * - returns the address of the allocation
 * On failure:
 * - returns `NULL`
 *
 * Fails if:
 * - allocation fails
 * - `size` or `len` are 0
 * - `size * len` would overflow
 */
void *tyrant_calloc(size_t size, size_t len);

/**
 * Allocates `size * len` bytes of initialized memory
 *
 * On success:
 * - returns the address of the allocation
 * On failure:
 * - returns `NULL`
 *
 * Fails if:
 * - allocation fails
 * - `size` or `len` are 0
 * - `size * len` would overflow
 */
void *tyrant_alloc_arr(size_t size, size_t len);

/**
 * Reallocates memory to `size` bytes
 *
 * If the new size is greater than the previous size of the allocation, the new
 * bytes will be uninitialized
 *
 * On success:
 * - returns the (possibly changed) address of the allocation
 * - `*ret_success` is set to `true`
 * On failure:
 * - returns the given pointer
 * - `*ret_success` is set to `false`
 *
 * Fails if:
 * - reallocation fails
 * - `size` is 0
 */
void *tyrant_realloc(void *ptr, size_t size, bool *ret_success);

/**
 * Reallocates memory to `size * len` bytes
 *
 * If the new size is greater than the previous size of the allocation, the new
 * bytes will be uninitialized
 *
 * On success:
 * - returns the (possibly changed) address of the allocation
 * - `*ret_success` is set to `true`
 * On failure:
 * - returns the given pointer
 * - `*ret_success` is set to `false`
 *
 * Fails if:
 * - reallocation fails
 * - `size` or `len` are 0
 * - `size * len` would overflow
 */
void *tyrant_realloc_arr(void *ptr, size_t size, size_t len,
		bool *ret_success);

/**
 * Frees previously allocated memory
 *
 * If `ptr` is `NULL`, a fairy dies (but the operation is otherwise safe)
 */
void tyrant_free(void *ptr);

/**
 * [DEPRECATED] -- not well thought out
 *
 * Adds two numbers with an upper bound
 *
 * If the sum would be greater than `cap`, `cap` is returned and `*ret_capped`
 * is set to `true`.
 * Otherwise, `a + b` is returned and `*ret_capped` is set to `false`.
 */
static inline size_t tyrant_add_size_capped(size_t a, size_t b, size_t cap,
		bool *ret_capped);

/**
 * [DEPRECATED] -- not well thought out
 *
 * Multiplies two numbers with an upper bound
 *
 * If the product would be greater than `cap`, `cap` is returned and
 * `*ret_capped` is set to `true`.
 * Otherwise, `a * b` is returned and `*ret_capped` is set to `false`.
 */
static inline size_t tyrant_multiply_size_capped(size_t a, size_t b, size_t cap,
		bool *ret_capped);

/* ### Inline definitions ### */

static inline size_t tyrant_add_size_capped(size_t a, size_t b, size_t cap,
		bool *ret_capped)
{
	if (a > cap || b > cap
			|| a > cap - b) {
		*ret_capped = true;
		return cap;
	}

	*ret_capped = false;
	return a + b;
}

static inline size_t tyrant_multiply_size_capped(size_t a, size_t b, size_t cap,
		bool *ret_capped)
{
	if (a == 0 || b == 0) {
		*ret_capped = false;
		return 0;
	}

	if (a > cap || b > cap
			|| a > cap / b) {
		*ret_capped = true;
		return cap;
	}

	*ret_capped = false;
	return a * b;
}

// Internal macro glue--please ignore
#define TYRANT__CONSTRUCT_VERSION_STRING(major, minor, patch) \
	TYRANT__STRINGIFY(major) \
	"." TYRANT__STRINGIFY(minor) \
	"." TYRANT__STRINGIFY(patch)
#define TYRANT__STRINGIFY(x) #x

#endif // tyrant_h
