# 🎛️ Reading State — Day 98

> How the UI turns bloc **state** into pixels: 4 widgets + 3 context methods.

---

## 🧱 The 4 Display Widgets

| Widget | Rebuilds UI? | Side effects? | Use when |
| :-- | :--: | :--: | :-- |
| **BlocBuilder** | ✅ | ❌ | turn state → UI |
| **BlocListener** | ❌ | ✅ | snackbar / navigate / dialog |
| **BlocConsumer** | ✅ | ✅ | need **both** (UI + snackbar) |
| **BlocSelector** | ✅ *(only on a slice change)* | ❌ | rebuild on **part** of state |

> **BlocConsumer = BlocBuilder + BlocListener** in one widget.
> `listener` = side effects (returns nothing). `builder` = the UI.

---

## 👆 The 3 Context Methods

| Method | Rebuilds? | Gives you | Use in |
| :-- | :--: | :-- | :-- |
| `context.read<B>()` | ❌ | the bloc | **callbacks** (onPressed) |
| `context.watch<B>()` | ✅ | the bloc (`.state`) | `build()`, whole state |
| `context.select<B,T>()` | ✅ *(on slice change)* | a derived slice | `build()`, part of state |

> **Rule:** reading to *do something* → `read`. Reading to *display* → `watch`. Displaying *one slice* → `select`.
> ⚠️ Never `watch`/`select` inside `onPressed` — use `read`.

---

## 🧰 What `Builder` was doing

`Builder` = a widget that just hands you a **fresh context one level deeper**.
We wrapped `context.watch` in it so **only that Text rebuilds**, not the whole screen.

```text
watch at top of build()  →  whole HomeScreen rebuilds  😬
watch inside a Builder   →  only the Builder rebuilds   ✅
```

It also solves the classic "`Scaffold.of(context)` can't find it" — Builder gives a context *below* the thing.

---

## 🔍 select vs BlocSelector (the subtle bit)

Same job (rebuild only when a **slice** changes). Difference = what the callback receives:

```dart
context.select<CounterBloc, bool>((bloc) => bloc.state.count.isEven); // gets the BLOC
BlocSelector<CounterBloc, CounterState, bool>(
  selector: (state) => state.count.isEven,                            // gets the STATE
  builder: (context, isEven) => Text('$isEven'),
);
```

> The **last type (`bool`)** = "what I pull out" = the selector's **return type**. You choose it (bool / int / String / ...).
