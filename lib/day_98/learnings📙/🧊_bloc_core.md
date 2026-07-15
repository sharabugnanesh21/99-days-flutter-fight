# 🧊 Bloc Core — Day 98

> **The whole idea:** you add an **Event**, the bloc **emit**s a new **State**, the UI redraws.
> Everything else is just a refinement of this one loop.

---

## 🔁 The Loop Everything Builds On

```text
 ┌──────────┐    add(Event)    ┌────────┐
 │    UI    │ ───────────────► │  Bloc  │
 │  widget  │ ◄─────────────── │        │
 └──────────┘    emit(State)   └───┬────┘
                                   │ reads (optional)
                                   ▼
                             ┌────────────┐
                             │ Repository │
                             └────────────┘
```

---

## 🥤 Cubit vs Bloc

Both hold state and `emit`. The difference is **how you talk to them**.

| | Cubit | Bloc |
| :-- | :-- | :-- |
| Trigger | call a **method** → `cubit.increment()` | add an **event** → `bloc.add(IncrementPressed())` |
| Define | `void increment() => emit(...)` | `on<IncrementPressed>((e, emit) => emit(...))` |
| Best for | simple state | async flows + a named record of what happened |

> We used **Bloc** everywhere in day_98.

---

## 🧩 A Bloc = 3 Files (the repeating pattern)

```text
counter_event.dart  →  what CAN happen   (IncrementPressed, ResetPressed, ...)
counter_state.dart  →  what to SHOW      (CounterState { count })
counter_bloc.dart   →  event ➜ state     (on<Event>((e, emit) => emit(...)))
```

Every feature (counter · toggle · user · nav) repeats this exact rhythm.

---

## ⚙️ Inside the Bloc

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {   // super() = INITIAL state
    on<IncrementPressed>((event, emit) {
      emit(state.copyWith(count: state.count + 1)); // emit = "here's the new state"
    });
  }
}
```

- **`state`** — a getter you **inherit** from the base class. Always the *current* state. You never declare it.
- **`super(...)`** — sets the **initial** state.
- **`emit(...)`** — pushes a new state → UI rebuilds.

---

## 📋 copyWith + Immutability

State is **immutable** — never edited in place. You always emit a **new** one.
`copyWith` = "a copy with a few fields changed" (keeps the rest):

```dart
emit(state.copyWith(count: state.count + 1)); // only count changes; other fields kept
```

> Barely matters for one field — earns its keep when state has many fields.
