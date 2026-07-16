# 🎛️ Reading State — ref.watch, ref.read, ref.listen

Three ways to access provider state, each for a different purpose.

---

## ref.watch — Subscribe + Rebuild

*"I want the current value AND to rebuild whenever it changes."*

```dart
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(counterProvider).counter;  // subscribe
    return Text('Count: $count');                       // rebuilds on change
  }
)
```

**Key rule:** Can only be called inside:
- `ConsumerWidget.build(context, ref)`
- `Consumer(builder: (context, ref, child) { ... })`

**Why wrap in Consumer instead of calling in HomeScreen's own build()?**
- If you call `ref.watch` in HomeScreen's build(), the **entire page** rebuilds on every change
- Wrapping just the Text in a Consumer scopes the rebuild to only that small widget
- This is the exact same optimization you did with `Builder` + `context.watch` in day_98

---

## ref.read — Get value once, NO subscription

*"I want the current value right now, but I don't care about future changes."*

```dart
ElevatedButton(
  onPressed: () {
    final count = ref.read(counterProvider).counter;  // one-time read
    print('Current count: $count');
    // doesn't rebuild when count changes later
  },
  child: const Text('Read'),
)
```

Perfect for callbacks (onPressed, onTap, etc.) where you just need the value at that moment.

---

## ref.listen — Side effects only

*"When this provider changes, do something (snackbar, navigate, log), but don't rebuild UI."*

```dart
ref.listen<CounterModelState>(counterProvider, (previous, next) {
  print('Count changed from ${previous?.counter} to ${next.counter}');
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(...));
});
```

**Called directly inside build()** (not inside a callback):
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(...);  // ← called here, at build time
  return Scaffold(...);
}
```

Riverpod safely tracks this — it's called once per rebuild-cycle, no duplicates.

---

## Consumer — Scoping rebuilds

A widget that creates its own scope with its own `ref`. Use it when you want only a small part of the page to rebuild.

```dart
// BAD: entire page rebuilds
Text('Count: ${ref.watch(counterProvider).counter}')

// GOOD: only this Text rebuilds
Consumer(
  builder: (context, ref, child) {
    return Text('Count: ${ref.watch(counterProvider).counter}');
  }
)
```

This is Riverpod's answer to day_98's `Builder` + `context.watch` pattern. Same idea, Riverpod-native.

**Optional `child` parameter:**
```dart
Consumer(
  builder: (context, ref, child) {
    final isLoading = ref.watch(loadingProvider);
    return Column(
      children: [
        isLoading ? Spinner() : Text('Done'),
        child,  // ← static widget that doesn't rebuild
      ],
    );
  },
  child: const StaticFooter(),  // built once, reused always
)
```

99% of the time, skip the `child`. It's a micro-optimization.

---

## .select() — Watch only a derived slice

*"I only care about THIS slice of the state. Ignore everything else."*

```dart
final isEven = ref.watch(
  counterProvider.select((state) => state.counter.isEven),
);
```

**Rebuilds only when isEven flips**, not on every number change.

Example: watching a user profile, but only the name:
```dart
final name = ref.watch(
  userProvider.select((user) => user.name),
);
```

If the user's email changes, this widget does NOT rebuild. If the name changes, it does.

**Why?** Performance. In a large app with many fields changing, `.select()` prevents unnecessary rebuilds.

---

## Three ref methods side-by-side

| Method | Subscribes? | Rebuilds? | When to use |
|---|---|---|---|
| `ref.watch()` | Yes | Yes | Display data that changes |
| `ref.read()` | No | No | Get value once in callback |
| `ref.listen()` | Yes | No | Side effects (snackbar, navigate) |

---

## Common pattern: ref.listen + Consumer combo

```dart
ref.listen<AsyncValue<List<String>?>>(userProvider, (previous, next) {
  next.whenOrNull(
    data: (users) {
      if (users != null) {
        ScaffoldMessenger.of(context).showSnackBar(...);  // side effect
      }
    },
    error: (err, st) {
      ScaffoldMessenger.of(context).showSnackBar(...);   // side effect
    },
  );
});

// Then separately: build the UI
Consumer(
  builder: (context, ref, child) {
    final userState = ref.watch(userProvider);
    return userState.when(
      data: (users) => ...,     // UI for each state
      loading: () => ...,
      error: (err, st) => ...,
    );
  }
)
```

This mirrors day_98's `BlocConsumer`: listener handles side effects, builder handles UI.

---

## Summary

- **ref.watch**: Subscribe + rebuild. Use in Consumer.
- **ref.read**: One-time read. Use in callbacks.
- **ref.listen**: Subscribe + side effects, no rebuild. Use in build().
- **Consumer**: Scope rebuilds to a small widget.
- **.select()**: Watch only a derived slice, ignore the rest.
