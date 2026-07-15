# ❓ My Doubts (quick answers) — Day 98

> The exact questions I asked, with short answers to jog my memory later.

---

**`create: (_) => ToggleBloc()` — does `_` mean context?**
Yes. Signature is `(BuildContext context) => ...`. We write `_` when we don't use it.

---

**Where does `state` come from with no variable declared?**
It's a getter **inherited** from `Bloc`/`Cubit`. `super(...)` sets its first value; every `emit()` updates it.

---

**Why `RepositoryProvider` / why not just pass the class directly?**
You *can* pass it directly. The provider buys (1) one shared instance and (2) testability (swap a fake). → see `📦_providers_and_di`.

---

**copyWith & Equatable — what/why?**
`copyWith` = a new state with a few fields changed (state is immutable).
`Equatable` = compare states by **value** so duplicate states are skipped. *(Not used yet in day_98.)*

---

**What is `Builder`?**
A widget that hands you a fresh, deeper `context`. We used it to **scope a rebuild** to a small area (and it also fixes "`.of(context)` can't find it").

---

**Why `BlocProvider` in the toggle screen, not in main?**
Placement = lifetime. Inside the screen → the bloc lives only there and **resets** each visit.

---

**How is the bloc shared / not destroyed on navigation?**
It's provided **above `MaterialApp`**. Pushing a route doesn't remove that provider → same instance everywhere.

---

**Why does the back button appear by default?**
`AppBar` auto-adds it when there's a screen to **pop** back to.

---

**Is `BlocListener` the whole body? Does its child rebuild?**
Listener = side effects only (no rebuild). Its `child` is static; the inner `BlocBuilder` rebuilds just the number.

---

**Why `bool` in `select` / `BlocSelector`?**
It's the type you **extract** = the selector's **return type**. You choose it (bool / int / String / ...).

---

**`Navigator.push` vs `MaterialPageRoute` — which do I use?**
Both together: `push` is the action, `MaterialPageRoute` is the destination you pass to it.
