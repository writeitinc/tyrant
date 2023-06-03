# Tyrant

`tyrant` is a thin wrapper around `stdlib`'s memory management functions, with
three additions:

### Overflow-checked array allocation:
```c
// stdlib

int *arr;
if (SIZE_MAX / sizeof(arr[0]) < len) {
	goto cleanup_42;
}

arr = malloc(sizeof(arr[0]) * len);
if (!arr) {
	goto cleanup_43;
}
```
```c
// tyrant

int *arr = tyrant_alloc_array(sizeof(arr[0]), len);
if (!arr) {
	goto windows_moment;
}
```

### Failed reallocations return the original pointer:
```c
// stdlib

void *tmp_obj = realloc(obj, new_size);
if (!tmp_obj) {
	goto pull_the_alarm;
}

obj = tmp_obj;
```
```c
// tyrant

bool success;
obj = tyrant_realloc(obj, new_size, &success);
if (!success) {
	goto f000_go_back;
}
```

### QOL functions & macros:
```c
void *arr = TYRANT_ALLOC_ARR(arr, len);
```
```c
bool success;
arr = TYRANT_REALLOC_ARR(arr, len, &success);
```
```c
bool success;
size_t half_cap = cap / 2;
size_t half_cap_rounded = half_cap + (cap % 2 == 1);
size_t new_cap = tyrant_add_size_capped(
        cap, half_cap_rounded, // geometric growth rate of 3/2
        SIZE_MAX,              // capped at SIZE_MAX
        &success);
```
```c
bool success;
size_t new_cap = tyrant_multiply_size_capped(
        cap, 2,   // geometric growth rate of 2
        SIZE_MAX, // capped at SIZE_MAX
        &success);
```
