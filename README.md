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

### QOL macros
```c
void *arr = TYRANT_ALLOC_ARR(arr, len);
```
```c
bool success;
arr = TYRANT_REALLOC_ARR(arr, len, &success);
```
