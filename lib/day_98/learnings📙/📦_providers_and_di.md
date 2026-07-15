# 📦 Providers & Dependency Injection — Day 98

> Providers put blocs / data into the tree so widgets below can grab them with `context.read<T>()`.

---

## 🧱 The 3 Providers

| Provider | Provides | Access with |
| :-- | :-- | :-- |
| **BlocProvider** | one bloc/cubit | `context.read<CounterBloc>()` |
| **MultiBlocProvider** | several blocs (nesting shorthand) | same |
| **RepositoryProvider** | a repository (plain data class) | `context.read<UserRepository>()` |

> Blocs auto-`close()` on dispose. Repositories aren't closed (nothing to close).

---

## ⏳ Placement = Lifetime

```text
Provider ABOVE MaterialApp   →  bloc lives the WHOLE app      (Counter, User)
Provider INSIDE a screen     →  bloc lives only on that screen (Toggle)
                                created on enter, close()d on exit
```

That's why the **counter persists** across screens but the **toggle resets** each visit.

---

## ♻️ create vs .value

| | `create:` | `.value` |
| :-- | :-- | :-- |
| Makes | a **new** bloc, and **owns** it (closes it) | reuses an **existing** bloc (won't close it) |
| Use for | first creation | handing a bloc to a pushed route |

> ⚠️ Never use `.value` to *create* a bloc — it won't get disposed.

---

## 💉 Dependency Injection (the "why `context.read`?")

You *can* just do `UserBloc(UserRepository())`. But we did:

```dart
BlocProvider(create: (context) => UserBloc(context.read<UserRepository>()))
```

Inside the bloc it's received as a **normal field** — no magic:

```dart
final UserRepository repository; // handed in, not created here
```

**Why hand it in instead of `new`-ing inside?**

1. **One shared instance** across all blocs (same cache / DB / HTTP client).
2. **Testability** — in a test, hand it a `FakeUserRepository()`. If the bloc built its own, you could never swap it.

> Dependency injection = *don't let a class build its own dependencies — hand them in from outside.*
> For a tiny app it's optional; it pays off the moment you write tests or share the repo.
