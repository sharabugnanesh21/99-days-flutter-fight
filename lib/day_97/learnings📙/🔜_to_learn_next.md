# 🔜 What's Next — Advanced Riverpod Topics

You've covered the fundamentals. Here's what's worth learning once these truly feel natural:

---

## 1. .family — Parameterized providers

**What:** A provider that takes a parameter, like a function.

**Example:**
```dart
final userByIdProvider = AsyncNotifierProvider.family<UserNotifier, User, int>(
  UserNotifier.new,
);

// Usage:
final user1 = ref.watch(userByIdProvider(123));  // fetch user 123
final user2 = ref.watch(userByIdProvider(456));  // fetch user 456
```

**When:** Fetching multiple items by ID, or user-specific data.

**Difficulty:** Medium. Syntax gets a bit complex, but the idea is simple: provider as a function.

---

## 2. @riverpod codegen — Less typing

**What:** Use Dart code generation to write providers with annotations instead of classes.

**Example:**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state = state + 1;
}

// Automatically generates: final counterProvider = ...
```

vs your current:
```dart
class CounterNotifier extends Notifier<int> { ... }
final counterProvider = NotifierProvider(...);
```

**When:** After you're 100% comfortable with manual providers. This is just syntax sugar.

**How:** Add `build_runner` to pubspec and run `dart run build_runner build`.

**Difficulty:** Medium. Same ideas, less boilerplate.

**Note:** This is optional. Manual is fine. Some projects prefer manual for explicitness.

---

## 3. Riverpod DevTools — Debugging

**What:** A browser-based inspector that shows all providers, their state, and how they're connected.

**Setup:**
```bash
dart pub global activate riverpod_devtools
riverpod_devtools
```

Then in your app:
```dart
ProviderScope(
  observers: [RiverpodObserver()],  // enable dev tools
  child: MyApp(),
)
```

**When:** When you have complex provider dependencies and need to debug state flow.

**Difficulty:** Easy. Just UI inspection.

---

## 4. FutureProvider and StreamProvider

**What:** Shorthand `AsyncNotifier` for simple cases that don't need custom methods.

**Example:**
```dart
// AsyncNotifier (what you learned) — full control
class UserNotifier extends AsyncNotifier<List<String>?> {
  @override
  Future<List<String>?> build() => repository.getUsers();
  
  Future<void> fetchUsers() async { ... }  // custom method
}

// vs FutureProvider — automatic
final userProvider = FutureProvider((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return await repo.getUsers();
});
```

FutureProvider auto-wraps in AsyncValue, no manual methods needed.

**When:** For simple "fetch and display" providers with no custom actions.

**Difficulty:** Easy. Similar to AsyncNotifier.

---

## 5. StateNotifierProvider — Old Riverpod API (avoid)

**What:** The v2 way of writing notifiers. `AsyncNotifier` is the newer, cleaner v3 way.

**Old (v2):**
```dart
class CounterStateNotifier extends StateNotifier<int> {
  CounterStateNotifier() : super(0);
  void increment() => state = state + 1;
}

final counterProvider = StateNotifierProvider((ref) => CounterStateNotifier());
```

**New (v3):**
```dart
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state = state + 1;
}

final counterProvider = NotifierProvider(...);
```

**When:** Skip this. You're already on v3. Only use if you see it in old code.

**Difficulty:** Easy to migrate, but why bother? v3 is better.

---

## 6. ChangeNotifierProvider — ChangeNotifier integration

**What:** If you're using `ChangeNotifier` from Flutter (older style), Riverpod can wrap it.

```dart
class MyChangeNotifier extends ChangeNotifier {
  int count = 0;
  void increment() {
    count++;
    notifyListeners();
  }
}

final provider = ChangeNotifierProvider((ref) => MyChangeNotifier());
```

**When:** Only if you already have code using ChangeNotifier.

**Difficulty:** Medium. But unnecessary if you're using Notifier.

**Note:** You tried this early (CounterModelState + ChangeNotifierProvider). Riverpod's native Notifier is cleaner. Stick with that.

---

## 7. Custom ref methods and extensions

**What:** Build helper methods that encapsulate common patterns.

**Example:**
```dart
// Without helper: verbose
final user = await ref.watch(userProvider.select((state) => state.when(
  data: (d) => d,
  loading: () => null,
  error: (err, st) => null,
)));

// With helper: clean
final user = ref.userData();  // custom extension
```

**When:** In large projects with repetitive watch/read patterns.

**Difficulty:** Medium. Requires understanding Dart extensions.

---

## 8. Error handling strategies

**What:** Beyond `.when()`, handling specific error types elegantly.

**Example:**
```dart
userState.whenOrNull(
  data: (users) => users?.isNotEmpty == true ? UserList(users) : NoUsers(),
  error: (err, st) {
    if (err is SocketException) return NoInternetWidget();
    if (err is TimeoutException) return TimeoutWidget();
    return GenericError(err);
  },
)
```

**When:** When your app handles different errors differently.

**Difficulty:** Medium. Mostly logic, no new Riverpod concepts.

---

## 9. Testing providers

**What:** Unit test your notifiers and providers in isolation.

**Example:**
```dart
test('counter increments', () {
  final container = ProviderContainer();
  expect(container.read(counterProvider), 0);
  
  container.read(counterProvider.notifier).increment();
  expect(container.read(counterProvider), 1);
});
```

**When:** Before shipping to production.

**Difficulty:** Easy. ProviderContainer is your testing friend.

---

## 10. Hydration — Persist provider state

**What:** Save provider state to local storage and restore it on app restart.

**Example:**
```dart
// Save counter to SharedPreferences
class PersistentCounterNotifier extends Notifier<int> {
  @override
  int build() {
    // load from SharedPrefs
  }
  
  void increment() {
    state = state + 1;
    // save to SharedPrefs
  }
}
```

**When:** For user preferences, cache, offline-first apps.

**Difficulty:** Medium. Combines Riverpod + local storage logic.

---

## Suggested learning order

1. ✅ **Basics** (you are here) — Notifier, AsyncNotifier, ref.watch/read/listen, Consumer
2. ⬜ **.family** — parameterized providers
3. ⬜ **@riverpod** — codegen (optional shorthand)
4. ⬜ **Testing** — unit test your providers
5. ⬜ **Error handling** — deal with specific error types
6. ⬜ **Hydration** — persist state
7. ⬜ **DevTools** — inspect state flow visually
8. ⬜ **Custom extensions** — build helpers
9. ⬜ **FutureProvider/StreamProvider** — shortcuts for simple cases

---

## Resources

- **Official docs:** https://riverpod.dev
- **Examples:** https://github.com/rrousselGit/riverpod/tree/master/examples
- **YouTube:** Search "Riverpod Flutter tutorial" (but verify they're using v3)

---

## Your next step

Once you're 100% confident in sections 1-7 of day_97, pick **ONE** from the list above and deep-dive. Start with **.family** — it's the most practical next concept. Then **testing** — it's how you verify your work.

Don't try to learn everything at once. **Depth first, breadth later.**
