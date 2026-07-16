# 📦 Providers and Dependency Injection

## What is a Provider?

A **provider** is a global, reusable reference to a notifier or value. It's NOT created yet — it's just a blueprint. When something watches it, Riverpod creates the actual notifier instance.

---

## Three provider types

### 1. NotifierProvider — Sync state

```dart
final counterProvider = NotifierProvider<CounterNotifier, CounterModelState>(
  CounterNotifier.new,
);
```

**Use for:** Simple, synchronous state (counter, toggle, form fields).

**Key:** No `.autoDispose` here, so it lives for the whole app. Every screen that watches it sees the SAME instance.

```dart
// Home sees count = 5
ref.watch(counterProvider).counter  // 5

// Details screen, same provider
ref.watch(counterProvider).counter  // still 5 (same instance!)

// Home increments
ref.read(counterProvider.notifier).increment()

// Details sees it updated
ref.watch(counterProvider).counter  // 6 (same notifier, shared state)
```

---

### 2. AsyncNotifierProvider — Async state with AsyncValue

```dart
final userProvider = AsyncNotifierProvider<UserNotifier, List<String>?>(
  UserNotifier.new,
);
```

**Use for:** Network requests, database queries, anything async.

**Returns:** `AsyncValue<T>` with built-in loading/data/error states.

```dart
final userState = ref.watch(userProvider);

userState.when(
  data: (users) => users == null ? Text('Not fetched') : UserList(users),
  loading: () => Spinner(),
  error: (err, st) => ErrorWidget(err),
);
```

---

### 3. Provider — Read-only value

```dart
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
```

**Use for:** Services, repositories, config objects that never change.

**Key:** No state, no notifier, no mutations. Just exposes a value.

```dart
final repo = ref.read(userRepositoryProvider);
final users = await repo.getUsers();  // call methods on it
```

Same reason you used `RepositoryProvider` in day_98: one shared instance, swappable for tests.

---

## NotifierProvider.autoDispose — Screen-scoped state

```dart
final toggleProvider = NotifierProvider.autoDispose<ToggleNotifier, bool>(
  ToggleNotifier.new,
);
```

Same as `NotifierProvider`, but with automatic cleanup.

**Lifetime:**
- Created when someone first watches it
- Destroyed when the last watcher leaves
- Recreated with fresh `build()` state if someone watches again later

This replaces day_98's screen-scoped `BlocProvider(create: ..., child: ...)` wrapper. Riverpod's approach is simpler: just a flag, not a widget.

---

## Provider composition — Watching other providers

A notifier can depend on other providers via `ref.watch`:

```dart
class UserNotifier extends AsyncNotifier<List<String>?> {
  @override
  Future<List<String>?> build() async {
    // Watch the repository provider inside build()
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getUsers();
  }
  
  Future<void> fetchUsers({bool simulateError = false}) async {
    state = const AsyncValue.loading();
    // Or read it (one-time, no subscription) inside a method
    final repository = ref.read(userRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.getUsers(fail: simulateError),
    );
  }
}
```

**Key difference:**
- `ref.watch(repo)` inside `build()` — subscribes, so if repo changes, rebuild
- `ref.read(repo)` inside a method — just get it once, no subscription

---

## Dependency Injection in Riverpod

**Day_98 (Bloc):**
```dart
RepositoryProvider(create: (_) => UserRepository()),  // provide repo
MultiBlocProvider(providers: [
  BlocProvider(create: (context) => CounterBloc()),
  BlocProvider(create: (context) => UserBloc(context.read<UserRepository>())),  // inject repo
])
```

You had to manually inject the repo into UserBloc's constructor.

**Day_97 (Riverpod):**
```dart
// Step 1: expose the repo
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Step 2: notifier just watches it, no constructor injection needed
class UserNotifier extends AsyncNotifier<List<String>?> {
  @override
  Future<List<String>?> build() async {
    final repo = ref.watch(userRepositoryProvider);  // get it here
    return await repo.getUsers();
  }
}

// Step 3: done! No explicit wiring in main.dart
```

**Riverpod's DI is simpler:** Just expose providers as top-level variables. Any notifier can watch any provider. No constructor parameters needed.

---

## Why global providers aren't "bad"

You might worry: *"aren't global variables bad?"*

**No, because:**
1. Providers are just references, not the actual notifier
2. The notifier is only created when first watched (lazy)
3. Riverpod tracks all listeners and cleans up unused ones
4. It's dependency injection, not a loose global like a singleton

It's more like a **service registry** than a "global variable."

---

## Provider vs Notifier

**Provider** = the reference/declaration (top-level `final`)
**Notifier** = the class that holds logic

```dart
// Notifier — the logic class
class CounterNotifier extends Notifier<CounterModelState> {
  @override
  CounterModelState build() => CounterModelState();
  void increment() => state = state.copyWith(counter: state.counter + 1);
}

// Provider — the reference to that notifier
final counterProvider = NotifierProvider<CounterNotifier, CounterModelState>(
  CounterNotifier.new,
);
```

Access the notifier's methods via `.notifier`:
```dart
ref.read(counterProvider.notifier).increment();  // ← .notifier gives you the notifier
```

Access the state directly without `.notifier`:
```dart
ref.watch(counterProvider);  // ← just the state value
```

---

## Summary

- **NotifierProvider**: Synchronous state, app-wide
- **NotifierProvider.autoDispose**: Synchronous state, screen-scoped (cleanup on no watchers)
- **AsyncNotifierProvider**: Async state, auto-wrapped in AsyncValue
- **Provider**: Read-only value (repo, config)
- **Composition**: Notifiers can watch other providers via `ref.watch/ref.read`
- **DI**: Just expose providers globally, no constructor injection needed
