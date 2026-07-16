# 🚀 Async State and Navigation — AsyncValue and ref.listen

## AsyncValue — The built-in async state wrapper

When you use `AsyncNotifier<T>`, Riverpod automatically wraps the result in `AsyncValue<T>`.

```dart
AsyncValue<List<String>?>
  ├─ AsyncLoading()              // waiting for the Future
  ├─ AsyncData(null)             // got null (our "not fetched yet" state)
  ├─ AsyncData([...])            // got the list
  └─ AsyncError(error, stack)    // Future threw an error
```

**This replaces day_98's 4 hand-written state classes:**
- `UserInitial` → `AsyncData(null)`
- `UserLoading` → `AsyncLoading()`
- `UserLoaded` → `AsyncData([...])`
- `UserError` → `AsyncError(err, st)`

Riverpod just gives them to you. You don't write them.

---

## AsyncValue.when() — Pattern matching on the 4 states

```dart
final userState = ref.watch(userProvider);

userState.when(
  data: (users) => users == null
      ? const Text('Press "Fetch users" to load.')
      : Column(children: users.map((u) => Text('• $u')).toList()),
  loading: () => const CircularProgressIndicator(),
  error: (err, st) => Text('Something went wrong: $err'),
);
```

**Each branch:**
- `data(T value)` — receives the actual data (including null for "not fetched")
- `loading()` — no args, just show a spinner
- `error(Object err, StackTrace st)` — receives error + stack trace

---

## AsyncValue.guard() — Auto try/catch

Replaces manual try/catch by running a Future and automatically catching errors.

```dart
state = await AsyncValue.guard(
  () => repository.getUsers(fail: simulateError),
);
```

Equivalent to:
```dart
try {
  state = AsyncValue.data(await repository.getUsers(fail: simulateError));
} catch (err, stack) {
  state = AsyncValue.error(err, stack);
}
```

**Much cleaner.** The guard handles the try/catch for you.

---

## Handling nullable data inside AsyncData

```dart
userState.when(
  data: (users) => users == null           // ← check for null inside data branch
      ? const Text('Not fetched yet.')
      : Column(children: [...]),
  loading: () => Spinner(),
  error: (err, st) => Error(),
);
```

Why is it nullable? Because you want to distinguish:
- `AsyncData(null)` = "not fetched yet" (Initial state)
- `AsyncData([...])` = "fetched and got a list"

The `AsyncData` wrapper itself means "we have a value or null." The `null` is just data.

---

## ref.listen — Side effects (snackbar, navigation)

Watches a provider and reacts to changes with side effects (no UI returned).

```dart
ref.listen<AsyncValue<List<String>?>>(userProvider, (previous, next) {
  next.whenOrNull(
    data: (users) {
      if (users != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded ${users.length} users ✅')),
        );
      }
    },
    error: (err, st) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $err ❌'),
          backgroundColor: Colors.red,
        ),
      );
    },
  );
});
```

**Key points:**
- Called directly inside `build()`, not inside a callback
- Uses `whenOrNull` to only react to specific branches
- No UI returned — just side effects
- Riverpod tracks it safely, called once per rebuild-cycle

This is Riverpod's answer to day_98's `BlocConsumer` listener branch.

---

## Navigation patterns

### Pattern 1: Direct Navigator.push (simple)

For straightforward "open a screen" buttons, just push directly:

```dart
ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const DetailsScreen()),
  ),
  child: const Text('Go to Details'),
)
```

Simple, no state needed. Use this when navigation doesn't depend on async results.

---

### Pattern 2: Navigate via provider signal (complex)

For navigation that depends on async results (e.g., "log in first, THEN navigate"):

```dart
// 1) Listen for the signal at build time
ref.listen<NavSignal?>(navProvider, (previous, next) {
  if (next == NavSignal.toggleScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ToggleScreen()),
    );
  }
});

// 2) Button calls a method on the provider (not Navigator.push directly)
ElevatedButton(
  onPressed: () => ref.read(navProvider.notifier).requestToggleScreen(),
  child: const Text('Go to Toggle (via signal)'),
)
```

The NavNotifier:
```dart
class NavNotifier extends Notifier<NavSignal?> {
  @override
  NavSignal? build() => null;

  void requestToggleScreen() {
    state = NavSignal.toggleScreen;  // ← fire the signal
    state = null;                    // ← reset, so tapping again re-triggers
  }
}
```

**Why this pattern?**
- Navigation becomes a side effect of a state change
- Useful when you need to navigate only after some async operation completes
- Cleaner separation: business logic (the notifier) vs UI effects (ref.listen)

This mirrors day_98's NavBloc pattern. Both say: *"don't navigate directly from a button, let a state change trigger navigation."*

---

## Choosing the right pattern

| Scenario | Use |
|---|---|
| "Tap button → open screen" (simple) | Direct `Navigator.push` |
| "Tap button → wait for login → navigate" (complex) | Provide signal + ref.listen |
| "Display list while loading" | `AsyncValue.when()` |
| "Show snackbar on success/error" | `ref.listen` + `whenOrNull` |

---

## Summary

- **AsyncValue** = Riverpod's built-in 4-state wrapper (loading/data/error)
- **.when()** = Pattern match on all 4 states
- **.whenOrNull()** = Pattern match on only the branches you care about
- **.guard()** = Run a Future, auto-catch errors into AsyncValue
- **ref.listen** = Subscribe + side effects (snackbar, navigation)
- **Direct Navigator** = simple, use when navigation is straightforward
- **Via provider signal** = complex, use when navigation depends on async results
