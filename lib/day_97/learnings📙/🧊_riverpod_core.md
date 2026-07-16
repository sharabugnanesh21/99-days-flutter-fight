# 🧊 Riverpod Core — State Management Without Events

## The mental shift from Bloc to Riverpod

**Bloc:** You write state classes + event classes. A button adds an event → bloc processes it → emits new state.

**Riverpod:** You write notifiers with plain methods. A button calls a method directly → method mutates state → Riverpod notices and rebuilds.

```dart
// BLOC (day_98)
context.read<CounterBloc>().add(IncrementPressed());  // add EVENT

// RIVERPOD (day_97)
ref.read(counterProvider.notifier).increment();       // call METHOD directly
```

No event classes needed. Simpler.

---

## Notifier<T> — Synchronous state

A class that holds ONE value and has methods to change it.

```dart
class CounterNotifier extends Notifier<CounterModelState> {
  @override
  CounterModelState build() => CounterModelState();  // initial value
  
  void increment() => state = state.copyWith(counter: state.counter + 1);
}
```

**Key rule:** Always **assign** to `state` (never just mutate). Riverpod detects the reassignment.

```dart
state = state.copyWith(...);  // ✅ Riverpod sees this → rebuilds
state.counter++;              // ❌ Riverpod doesn't notice → no rebuild
```

---

## AsyncNotifier<T> — Asynchronous state with built-in loading/error

Like Notifier, but for futures. Riverpod wraps the result in `AsyncValue<T>`, automatically handling loading/data/error.

```dart
class UserNotifier extends AsyncNotifier<List<String>?> {
  @override
  Future<List<String>?> build() async => null;  // initial state (not fetched yet)
  
  Future<void> fetchUsers({bool simulateError = false}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.getUsers(fail: simulateError),
    );
  }
}
```

**AsyncValue automatically provides:**
- `AsyncLoading()` — waiting for the future
- `AsyncData(value)` — got data back
- `AsyncError(error, stack)` — future threw an error

No need to write 4 state classes like you did in day_98. Riverpod gives them to you.

---

## Provider — Read-only value

A provider that exposes a value that never changes. Perfect for repositories and services.

```dart
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
```

Use it like: `ref.read(userRepositoryProvider)` or `ref.watch(userRepositoryProvider)`.

---

## NotifierProvider vs AsyncNotifierProvider

| | NotifierProvider | AsyncNotifierProvider |
|---|---|---|
| State type | `Notifier<T>` | `AsyncNotifier<T>` |
| Build returns | `T` (immediate) | `Future<T>` (async) |
| State is wrapped in | Just `T` | `AsyncValue<T>` |
| When to use | Counter, toggle, flags | Network requests, database queries |

---

## .autoDispose — Automatic cleanup

A flag that tells Riverpod: *"when nobody is watching this provider anymore, throw its state away."*

```dart
final toggleProvider = NotifierProvider.autoDispose<ToggleNotifier, bool>(
  ToggleNotifier.new,
);
```

**Lifecycle:**
1. Open ToggleScreen → `ref.watch(toggleProvider)` → provider created, build() runs
2. Toggle it → state changes
3. Pop ToggleScreen → nobody watching → `.autoDispose` kicks in → provider destroyed
4. Open ToggleScreen again → provider recreated with fresh state (OFF)

This replaces day_98's screen-scoped `BlocProvider(child: ...)` wrapper. Same outcome, different mechanism: Riverpod uses listener count instead of widget tree position.

---

## Key differences from Bloc

| Aspect | Bloc | Riverpod |
|---|---|---|
| State classes | YOU write (CounterState, UserInitial, etc.) | Riverpod provides (AsyncValue) |
| Events | Add events to the bloc | Call methods on the notifier |
| Scoping | Wrap provider in widget tree | Use `.autoDispose` flag |
| Initial state | `super(initialState)` | `build()` method |
| Type safety | Type-safe (state classes) | Type-safe (generics) |

---

## Summary

- **Notifier** = simple state holder + methods
- **AsyncNotifier** = async state holder + AsyncValue wrapper (loading/data/error)
- **Provider** = read-only exposed value (repositories, configs)
- **NotifierProvider** = exposes a Notifier
- **AsyncNotifierProvider** = exposes an AsyncNotifier + wraps in AsyncValue
- **.autoDispose** = auto-cleanup when nobody's watching
- **state assignment** = the signal that tells Riverpod "something changed"
