# 🔑 Flutter Keys — Day 99

> **One-line idea:** A key tells Flutter *"this widget is **this specific** one."*
> It's about **identity**.

---

## 🌳 The Family Tree

```text
Key (abstract)
│
├── LocalKey   → identity among SIBLINGS (same parent)
│   ├── ValueKey    → identity from a value
│   ├── ObjectKey   → identity from an object
│   └── UniqueKey   → always unique (forces "brand new")
│
└── GlobalKey  → identity across the WHOLE app + gives you the State/context
    ├── GlobalKey<T extends State>   → e.g. GlobalKey<FormState>  ← your formKey
    ├── GlobalObjectKey
    └── LabeledGlobalKey
```

---

## 🔑 The Big Split (this is the key insight)

| Family | What it gives you |
| :-- | :-- |
| **LocalKey** | Helps Flutter tell **sibling** widgets apart (mostly in lists). It does **not** give you access to anything. |
| **GlobalKey** | Gives you a **handle** to a widget's **State / context** from anywhere. That's why your `formKey` can call `validate()`. |

---

## 🧰 The Common Ones

| Key | What it does | Typical use |
| :-- | :-- | :-- |
| `ValueKey` | identity from a value → `ValueKey(item.id)` | list items so reordering / deleting works correctly |
| `ObjectKey` | identity from an object's `==` | list items keyed by a whole object |
| `UniqueKey` | unique every build → Flutter treats it as a **new** widget | force a widget to **reset / rebuild** from scratch |
| `GlobalKey<State>` | reach into a widget's **state** | `validate()` a Form, open a Drawer, etc. |

---

## 🎯 When You Actually Reach for Each

- **Lists that reorder / add / remove** → `ValueKey` (with a **stable id**).
  > ⚠️ Without it, Flutter can mix up which row is which and **state sticks to the wrong item**.

- **"Reset this widget completely"** → `UniqueKey` — changing the key **throws away** the old state.

- **"Control another widget from outside"** → `GlobalKey<SomeState>`:
  - `GlobalKey<FormState>` → `validate()` / `save()` / `reset()` a form  ← **what you're using**
  - `GlobalKey<FormFieldState>` → validate **one** field
  - `GlobalKey<ScaffoldState>` → open a drawer, show a bottom sheet

---

## 🔗 Tie-Back to Your Code

```dart
final formKey = GlobalKey<FormState>();
// ...
formKey.currentState!.validate();
```

Your `formKey` is a **GlobalKey**. That family is special because it's the **only one**
that hands you the widget's `State` — which is exactly how `formKey.currentState!.validate()` works.

> A `ValueKey` **couldn't** do that; it's just an identity tag.

---

## 📝 The One-Line Summary

| | Meaning | For whom |
| :-- | :-- | :-- |
| **LocalKeys** (`ValueKey`, `ObjectKey`, `UniqueKey`) | *"which widget is which"* | for **Flutter**, mostly in lists |
| **GlobalKeys** | *"let me grab this widget's state"* | for **you**, to control it from outside |

---

> ⚠️ **Cost note:** GlobalKeys are **expensive** — only use them when you genuinely need to
> reach a widget's state (like forms). For lists, **always prefer `ValueKey`**.
> Don't reach for a GlobalKey just to identify list items.
