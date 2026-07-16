# ❓ Common Doubts and Clarifications

## Q1: Why do I have to wrap in Consumer if I can just call ref.watch directly?

**A:** You CAN call `ref.watch` directly in ConsumerWidget's build. But it rebuilds the ENTIRE page.

```dart
class HomeScreen extends ConsumerWidget {
  build(context, ref) {
    final count = ref.watch(counterProvider);  // ← rebuilds ENTIRE HomeScreen
    return Column(
      children: [
        Text('Count: $count'),  // rebuilds
        ExpensiveWidget(),       // rebuilds too (wasteful!)
        AnotherWidget(),         // rebuilds too (wasteful!)
      ],
    );
  }
}
```

Wrapping in Consumer scopes the rebuild:
```dart
Column(
  children: [
    Consumer(
      builder: (context, ref, child) {
        final count = ref.watch(counterProvider);
        return Text('Count: $count');  // ONLY this rebuilds
      },
    ),
    ExpensiveWidget(),  // doesn't rebuild
    AnotherWidget(),    // doesn't rebuild
  ],
)
```

**Rule of thumb:** Use Consumer whenever you're watching in a Consumer widget's build, to avoid cascading rebuilds.

---

## Q2: What's the difference between ref.watch and context.watch?

**A:** `ref.watch` is Riverpod. `context.watch` is Bloc.

- **Riverpod:** `ref.watch(provider)` — watch providers
- **Bloc:** `context.watch<Bloc>()` — watch blocs via the widget tree

Different tools, same job. Riverpod's `ref` is simpler because it doesn't rely on the widget tree.

---

## Q3: Can I call ref.watch inside a button's onPressed?

**A:** No. It must be called at build time.

```dart
// ❌ WRONG
ElevatedButton(
  onPressed: () {
    final count = ref.watch(counterProvider);  // ERROR: ref doesn't exist here
  },
  child: Text('Tap'),
)

// ✅ RIGHT: use ref.read for one-time reads
ElevatedButton(
  onPressed: () {
    final count = ref.read(counterProvider).counter;
    print('Count is: $count');  // read, don't watch
  },
  child: Text('Tap'),
)
```

**ref rules:**
- `ref.watch` = only in build()
- `ref.read` = anywhere (callbacks, methods)
- `ref.listen` = only in build()

---

## Q4: Why is .autoDispose not needed for counterProvider but needed for toggleProvider?

**A:** Different lifetimes:

- **counterProvider** (no autoDispose) = app-wide, lives forever (like a Bloc provided above MaterialApp)
- **toggleProvider** (.autoDispose) = screen-scoped, dies when the screen exits (like a screen-scoped BlocProvider)

**When to use .autoDispose:**
- Screen-specific state (toggle, form, filter)
- Data fetched for ONE screen
- Anything that should reset when you leave

**When NOT to use .autoDispose:**
- Global state (counter, logged-in user, theme)
- Anything that persists across screens

---

## Q5: Why does the state need to be nullable (List<String>?) in userProvider?

**A:** To distinguish "not fetched yet" from "fetched and got an empty list."

```dart
AsyncData(null)  // ← haven't called fetchUsers() yet (Initial)
AsyncData([])    // ← called fetchUsers() and got an empty list (Loaded with 0 users)
```

The nullable data lets you show different UI:
```dart
userState.when(
  data: (users) => users == null
      ? Text('Press "Fetch users"')         // initial
      : users.isEmpty
          ? Text('No users found')          // fetched, but empty
          : UserList(users),                // fetched, has data
  ...
)
```

---

## Q6: What's the difference between state = AsyncValue.loading() and state = const AsyncValue.loading()?

**A:** `const` makes it a compile-time constant. Both work, but `const` is slightly more efficient (Dart reuses the same object).

For loading (which has no data), it doesn't matter. For data, you must NOT use const:
```dart
state = const AsyncValue.loading();  // ✅ OK, no data to vary
state = AsyncValue.data([...]);      // ❌ NOT const (data varies)
```

---

## Q7: Why do I use ref.read(provider.notifier) but ref.watch(provider) (no .notifier)?

**A:** 
- `ref.watch(provider)` = watch the STATE value
- `ref.watch(provider.notifier)` = watch the NOTIFIER itself (rarely used)
- `ref.read(provider)` = read the STATE value once
- `ref.read(provider.notifier)` = read the NOTIFIER once (use this to call methods)

```dart
final count = ref.watch(counterProvider).counter;           // ← state
ref.read(counterProvider.notifier).increment();            // ← notifier (has the method)
```

When you need to call a method, reach for `.notifier`. When you need data, skip it.

---

## Q8: Can AsyncNotifier use .autoDispose?

**A:** Yes! `AsyncNotifierProvider.autoDispose` works the same way.

```dart
final userProvider = AsyncNotifierProvider.autoDispose<UserNotifier, List<String>?>(
  UserNotifier.new,
);
```

When you leave the screen and nobody is watching, the provider is destroyed (including its current AsyncValue state).

---

## Q9: What if the Future in AsyncValue.guard() succeeds but the data is null?

**A:** That's fine. AsyncValue.data(null) is a valid state.

```dart
state = await AsyncValue.guard(() async => null);  // ← AsyncValue.data(null)
```

This is your "not fetched yet" state for userProvider. The AsyncData wrapper just means "we have a result" (which could be null).

---

## Q10: Why doesn't every provider use .autoDispose?

**A:** Performance. `.autoDispose` adds a tiny bit of overhead (tracking listeners). For global, long-lived providers (counter, app settings), it's wasteful.

Only use `.autoDispose` for screen-scoped or temporary state.

---

## Q11: What happens if I call ref.watch inside a callback (not build)?

**A:** It throws an error: *"cannot use ref outside of a widget"* (or similar). `ref` only exists in build-time contexts (ConsumerWidget.build, Consumer builder, etc.).

For callbacks, use `ref.read` instead.

---

## Q12: Is Riverpod's DI really simpler than Bloc's?

**A:** Yes. Compare:

**Bloc (manual wiring in main.dart):**
```dart
RepositoryProvider(create: (_) => UserRepository()),
MultiBlocProvider(providers: [
  BlocProvider(create: (_) => CounterBloc()),
  BlocProvider(create: (context) => UserBloc(context.read<UserRepository>())),
])
```

**Riverpod (auto-discovered):**
```dart
// Just declare providers globally
final userRepositoryProvider = Provider(...);
final userProvider = AsyncNotifierProvider(...);
// Done! No wiring in main.dart needed.
```

Riverpod finds all providers at the top level. No explicit registration.
