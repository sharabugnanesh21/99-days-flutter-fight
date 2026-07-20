# 📦 Provider Package — Simple State Management

## What is the Provider package?

The **Provider package** is a state management library built on `ChangeNotifier` + `InheritedWidget`. It's simpler than Bloc, older than Riverpod, and still widely used.

---

## Core pattern: ChangeNotifier

A plain Dart class that notifies listeners when its state changes.

```dart
class Counter extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();  // ← tell Provider "state changed, rebuild"
  }
}
```

**Key difference from Riverpod:** You mutate state IN PLACE (`_count++`), then call `notifyListeners()`. No `state =` assignment needed.

---

## Wiring: MultiProvider in main.dart

Expose all notifiers at the app root:

```dart
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
      ChangeNotifierProvider(create: (_) => User(repository)),
      ChangeNotifierProvider(create: (_) => Toggle()),
    ],
    child: MaterialApp(home: HomeScreen()),
  ),
);
```

This makes Counter, User, Toggle available everywhere in the app (like day_98's Bloc providers).

---

## Reading state: context.watch / context.read

In any widget, access the providers via `context`:

```dart
// Watch: subscribe + rebuild
Consumer<Counter>(
  builder: (context, counter, child) {
    return Text('Count: ${counter.count}');  // rebuilds on change
  },
)

// Read: one-time access, no subscription
ElevatedButton(
  onPressed: () => context.read<Counter>().increment(),
  child: const Text('+'),
)
```

**Same as Bloc's context.watch / context.read, different framework.**

---

## Consumer widget

Scopes a rebuild to just that widget (no need to rebuild the whole page):

```dart
Consumer<Counter>(
  builder: (context, counter, child) {
    return Text('${counter.count}');  // ONLY this rebuilds
  },
)
```

This is the exact reason you used `Builder` + `context.watch` in day_98.

---

## Async data

For loading/error states, manually track them:

```dart
class User extends ChangeNotifier {
  bool isLoading = false;
  List<String>? users;
  String? error;
  
  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    
    try {
      users = await repository.getUsers();
      error = null;
    } catch (e) {
      error = e.toString();
      users = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
```

Then in the UI:

```dart
if (user.isLoading) {
  return CircularProgressIndicator();
} else if (user.error != null) {
  return Text('Error: ${user.error}');
} else {
  return UserList(user.users);
}
```

**Difference from Riverpod:** Riverpod gives you `AsyncValue<T>` for free with `.when()`. Provider requires manual state tracking.

---

## Day 96 vs Day 97 vs Day 98

| | Day 98 (Bloc) | Day 97 (Riverpod) | Day 96 (Provider) |
|---|---|---|---|
| Base | Events + emit | Functional, reactive | Mutable, simpler |
| State | Hand-written classes | AsyncValue wrapper | Manual tracking |
| Access | context.watch/read | ref.watch/read | context.watch/read |
| Notifier | Bloc class | Notifier class | ChangeNotifier class |
| Wiring | MultiBlocProvider | ProviderScope | MultiProvider |
| Async | 4 state classes | AsyncValue built-in | Manual (isLoading, error, data) |

---

## When to use Provider package?

- **Small apps** with simple state
- **Learning state management** (simplest foundation)
- **Legacy codebases** already using Provider
- **Not** for complex async flows (use Riverpod or Bloc instead)

---

## Summary

Provider = **mutable state + notify pattern**. Simpler than Bloc, less powerful than Riverpod. Good for learning, fine for small projects.

**Key takeaway:** Provider and Bloc both use `context.watch/read`, but under the hood they're different. Riverpod is newer, uses `ref` instead of `context`, and handles async automatically.
