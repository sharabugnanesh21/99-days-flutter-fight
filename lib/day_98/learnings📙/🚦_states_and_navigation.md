# 🚦 States & Navigation — Day 98

> The 4 async states, and how screens share one bloc.

---

## 🔄 The 4 Classic States

```text
UserInitial ──add(FetchUsers)──► UserLoading ──► UserLoaded(data)   ✅
                                            └──► UserError(message)  ❌
```

| State | Means | UI |
| :-- | :-- | :-- |
| `UserInitial` | nothing yet | a prompt |
| `UserLoading` | request in flight | spinner |
| `UserLoaded` | success + data | the list |
| `UserError` | failure + message | error text |

> One **async** handler can `emit` **several** states over time (loading → result).
> That sequence is exactly what plain `setState` can't express cleanly — the reason Bloc exists.

---

## 🧭 Navigation = push + route

```dart
Navigator.push(                    // the ACTION ("put a screen on the stack")
  context,
  MaterialPageRoute(               // the DESTINATION + transition
    builder: (_) => const DetailsScreen(),
  ),
);
```

- `Navigator.push` = verb · `MaterialPageRoute` = noun (which screen).
- ⬅️ Back button appears **automatically** on pushed screens (there's something to pop).
- *(`context.push('/x')` style is from router packages like go_router — different system.)*

---

## 🔗 Why the counter is SHARED across screens

`Navigator.push` adds a screen ON TOP — it does **not** rebuild from the root, so the provider up top is untouched.

```text
[ CounterBloc — top of tree, never removed ]
        │
   MaterialApp
        │
  HomeScreen ──push──► DetailsScreen     (both look UP, find the SAME bloc)
```

> A bloc is destroyed only when **its provider** leaves the tree.

---

## 📨 Navigate via Bloc (event → listener)

Navigation is a **side effect**, so it lives in a **listener**, never a builder.

```text
tap → add(ToggleScreenRequested) → NavBloc emits GoToToggleScreen
    → BlocListener hears it → Navigator.push
```

> ⚠️ For a plain "open a screen" button, raw `Navigator.push` is better.
> This pattern earns its place when navigation follows an **async result** (login success → dashboard).
