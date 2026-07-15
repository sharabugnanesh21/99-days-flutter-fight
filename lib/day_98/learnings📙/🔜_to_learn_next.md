# 🔜 To Learn Next (advanced Bloc) — Day 98

> Stuff I haven't done yet. A short reference for when a feature needs it.
> Tiers: **Core+** (learn first) · **Intermediate** · **Advanced**.

---

## 🎚️ buildWhen / listenWhen · *Core+*

A gate — rebuild/fire only on certain changes.

```dart
buildWhen: (prev, cur) => prev.count != cur.count, // rebuild only if count changed
```

```text
State changed → buildWhen(prev,cur)? ── true ─► rebuild
                                     └─ false ─► skip
```

**Use when:** state has many fields but a widget cares about one; or a listener fires too often.

---

## 🟰 Equatable · *Core+*

Compare states by **value** → skip redundant rebuilds.

```dart
class CounterState extends Equatable {
  final int count;
  const CounterState({this.count = 0});
  @override
  List<Object?> get props => [count]; // fields that define equality
}
```

**Use when:** always, in real apps (~3 lines per state).

---

## ♻️ BlocProvider.value · *Core+*

Reuse an **existing** bloc for a pushed route (don't create a new one).

```dart
BlocProvider.value(
  value: context.read<CounterBloc>(),
  child: const DetailsScreen(),
);
```

**Use when:** a screen-scoped bloc must be seen by a route pushed outside its provider.

---

## 🔭 BlocObserver · *Core+*

A global spy — logs **every** bloc's events + transitions.

```dart
class AppObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition t) {
    super.onTransition(bloc, t);
    print('${bloc.runtimeType}  $t');
  }
}

void main() {
  Bloc.observer = AppObserver(); // one line, spies on all blocs
  runApp(const MyApp());
}
```

**Use when:** debugging "wait, why did that rebuild/fire?".

---

## 🌊 emit.forEach / streams · *Intermediate*

Feed a **Stream** into a handler (auto-cancels on close).

```dart
on<StartTicker>((event, emit) async {
  await emit.forEach<int>(
    tickerStream(),                     // a Stream<int>
    onData: (tick) => TimerState(tick), // emit a state per tick
  );
});
```

**Use when:** real-time sources — timers, websockets, Firebase streams, location.

---

## 🧱 sealed classes / freezed · *Intermediate*

Make the **compiler force** you to handle every state.

```dart
final view = switch (state) {
  UserLoading()            => const CircularProgressIndicator(),
  UserLoaded(:final users) => UserList(users),
  UserError(:final msg)    => Text(msg),
}; // compile error if a case is missing
```

**Use when:** states with several variants (replaces `if (state is ...)` chains).
`freezed` also generates `copyWith` + equality (needs build_runner).

---

## 💾 HydratedBloc · *Advanced*

Auto **save/restore** state to disk.

```dart
@override
CounterState? fromJson(Map<String, dynamic> json) =>
    CounterState(count: json['count'] as int);

@override
Map<String, dynamic>? toJson(CounterState state) => {'count': state.count};
```

```text
state change ──toJson──► disk
disk ──fromJson on app start──► restored state
```

**Use when:** state should survive an app restart (theme, cart, counter, onboarding).

---

### 🧭 Suggested order

> Start with **Equatable + buildWhen** (small, high value) → add a **BlocObserver** to watch it live → pull in the rest only when a feature asks.
