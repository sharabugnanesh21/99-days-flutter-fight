// ============================================================================
// HOME SCREEN (Riverpod version of day_98's home_screen.dart)
//
// Each numbered section demonstrates ONE Riverpod concept, and calls out the
// Bloc equivalent from day_98 so you can map old -> new as you read. The
// section numbers here match day_98's 1-7 exactly, so you can open both
// files side by side and compare section-for-section.
//
// Big picture translation table (keep this in your head while reading):
//   BlocBuilder                          -> ref.watch (you're ALREADY inside
//                                            a ConsumerWidget's build(), so
//                                            watching IS the rebuild trigger)
//   context.read<Bloc>().add(event)      -> ref.read(provider.notifier).method()
//   Builder + context.watch              -> Consumer(builder: ...)
//   context.select / BlocSelector        -> ref.watch(provider.select(...))
//   BlocConsumer (listener + builder)    -> ref.listen(...) + AsyncValue.when()
//   4 hand-written UserState classes     -> built-in AsyncValue (data/loading/error)
//   bloc provided above MaterialApp      -> provider declared top-level, no autoDispose
//   screen-scoped BlocProvider           -> provider declared top-level, .autoDispose flag
//   NavBloc "signal state" pattern       -> a Notifier<NavSignal?> + ref.listen
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../counter/counter_provider.dart';
import '../user/user_provider.dart';
import '../nav/nav_provider.dart';
import 'details_screen.dart';
import 'toggle_screen.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ==========================================================================
    // 7) Navigate via provider (event-like pattern) — registered here.
    //
    //    ref.listen is for SIDE EFFECTS ONLY (snackbar, navigation) — never put
    //    navigation logic inside .when()/builder code. It must be called
    //    directly inside build() (not inside a callback) — Riverpod tracks it
    //    per rebuild-cycle safely, same spirit as day_98's BlocConsumer
    //    `listener:` running alongside `builder:`.
    //
    //    Here we watch navProvider: when requestToggleScreen() sets state to
    //    NavSignal.toggleScreen, we navigate. This is the Riverpod parallel of
    //    day_98's NavBloc "add event -> BlocListener reacts -> push route"
    //    pattern — useful when navigation depends on an async result (e.g.
    //    "navigate only after a save succeeds"). Section 6 below shows the
    //    simpler direct Navigator.push way — both are shown so you can compare.
    // ==========================================================================
    ref.listen<NavSignal?>(navProvider, (previous, next) {
      if (next == NavSignal.toggleScreen) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ToggleScreen()),
        );
      }
    });

    // ==========================================================================
    // 5) ref.listen for the user-fetch side effects (snackbar only).
    //
    //    This is the "listener:" half of day_98's BlocConsumer<UserBloc,
    //    UserState>. It runs for its side effects and returns nothing — the
    //    UI itself is built further down by userState.when(...).
    //
    //    whenOrNull lets us react only to the branches we care about (data /
    //    error) and ignore loading here, since there's no side effect needed
    //    while loading.
    // ==========================================================================
    ref.listen<AsyncValue<List<String>?>>(userProvider, (previous, next) {
      next.whenOrNull(
        data: (users) {
          if (users != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Loaded ${users.length} users ✅')),
            );
          }
        },
        error: (err, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $err ❌'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Demo — Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // 1) Consumer + ref.watch
            //
            //    ref.watch(counterProvider) subscribes AND rebuilds whenever
            //    counterProvider's state changes. This covers what BlocBuilder
            //    did in day_98: watching a provider IS the rebuild trigger.
            //
            //    Notice this is wrapped in a Consumer, not called directly in
            //    HomeScreen's own build(). That's deliberate: a `ref` obtained
            //    from ConsumerWidget.build(context, ref) belongs to HomeScreen's
            //    OWN element — calling ref.watch with it, anywhere in this
            //    file, would rebuild the ENTIRE HomeScreen (every section) on
            //    every count change. Consumer creates its OWN element with its
            //    OWN ref, so a watch made through IT only rebuilds this bit.
            //    (Section 3 spells this out in full; sections 4 and 5 use the
            //    same trick.)
            // ================================================================
            const _Title('1) Consumer + ref.watch'),
            Consumer(
              builder: (context, ref, child) {
                return Text(
                  '${ref.watch(counterProvider).counter}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),

            // ================================================================
            // 2) ref.read + notifier methods
            //
            //    ref.read(counterProvider.notifier) gets the NOTIFIER itself
            //    (not the value) without subscribing — perfect for one-off
            //    calls inside callbacks like onPressed. This replaces day_98's
            //    context.read<CounterBloc>().add(IncrementPressed()): no event
            //    classes needed, you just call a plain method directly on the
            //    notifier (increment / decrement / reset).
            // ================================================================
            const _Title('2) ref.read + notifier methods'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ref.read(counterProvider.notifier).increment(),
                  child: const Text('+'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(counterProvider.notifier).decrement(),
                  child: const Text('-'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).reset(),
                  child: const Text('reset'),
                ),
              ],
            ),
            const Divider(height: 32),

            // ================================================================
            // 3) Consumer — scoping a rebuild
            //
            //    We're already inside HomeScreen's ConsumerWidget build(), so
            //    we COULD call ref.watch(counterProvider) right here directly.
            //    But doing that would rebuild the ENTIRE HomeScreen (every
            //    section) on every single count change. Wrapping just this
            //    Text in a Consumer scopes the rebuild down to only this small
            //    widget — exactly the same reason day_98 wrapped
            //    context.watch in a Builder: isolate the "watch" to the
            //    smallest widget that needs it.
            // ================================================================
            const _Title('3) Consumer — scoping a rebuild'),
            Consumer(
              builder: (context, ref, child) {
                final count = ref.watch(counterProvider).counter;
                return Text('Watched count: $count');
              },
            ),
            const Divider(height: 32),

            // ================================================================
            // 4) ref.watch(provider.select(...))
            //
            //    .select() lets us rebuild ONLY when a DERIVED slice of the
            //    state changes — here, even/odd-ness — instead of on every
            //    single increment. Tap "+" repeatedly in section 2: this line
            //    only flips between EVEN and ODD, it doesn't rebuild for
            //    every number in between. Same idea, same `bool` generic, as
            //    day_98's context.select<CounterBloc, bool> /
            //    BlocSelector<..., bool>.
            //
            //    Wrapped in Consumer (not a plain Builder) for the same
            //    reason as section 1 — this ref must be Consumer's OWN ref so
            //    the EVEN/ODD flip only rebuilds this bit, not the whole page.
            // ================================================================
            const _Title('4) ref.watch(provider.select(...))'),
            Consumer(
              builder: (context, ref, child) {
                final isEven = ref.watch(
                  counterProvider.select((state) => state.counter.isEven),
                );
                return Text('select -> ${isEven ? "EVEN" : "ODD"}');
              },
            ),
            const Divider(height: 32),

            // ================================================================
            // 5) AsyncValue + .when() + ref.listen (the 4 states)
            //
            //    userProvider exposes AsyncValue<List<String>?>. AsyncValue
            //    .when's 3 branches (data / loading / error) are what
            //    REPLACED day_98's 4 hand-written classes (UserInitial /
            //    UserLoading / UserLoaded / UserError) — here data(null)
            //    stands in for "Initial" (nothing fetched yet). Also note:
            //    UserNotifier.fetchUsers() used AsyncValue.guard() to run the
            //    repository call, which replaced the manual try/catch
            //    day_98's UserBloc had to write by hand.
            //
            //    The side-effect half (snackbar on success/error) is the
            //    ref.listen registered up at the top of build() — that's the
            //    "listener:" half of day_98's BlocConsumer. What you see
            //    below is only the "builder:" half.
            //
            //    Wrapped in Consumer (not a plain Builder), same reason as
            //    sections 1 and 4 — so a loading/data/error transition only
            //    rebuilds this bit, not the whole page.
            // ================================================================
            const _Title('5) AsyncValue + .when() + ref.listen (4 states)'),
            Consumer(
              builder: (context, ref, child) {
                final userState = ref.watch(userProvider);
                return userState.when(
                  data: (users) => users == null
                      ? const Text('Press "Fetch users" to load.')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: users.map((u) => Text('• $u')).toList(),
                        ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, st) => Text('Something went wrong: $err'),
                );
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ref.read(userProvider.notifier).fetchUsers(),
                  child: const Text('Fetch users'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => ref
                      .read(userProvider.notifier)
                      .fetchUsers(simulateError: true),
                  child: const Text('Fetch (force error)'),
                ),
              ],
            ),
            const Divider(height: 32),

            // ================================================================
            // 6) Navigation — shared state & autoDispose, side by side.
            //
            //    "Go to Details": counterProvider is declared top-level with
            //    NO autoDispose, so it's app-wide — DetailsScreen watching
            //    counterProvider sees the EXACT SAME instance/state as
            //    HomeScreen, no re-creation on navigation. Riverpod parallel
            //    of day_98's bloc being provided ABOVE MaterialApp.
            //
            //    "Go to Toggle": toggleProvider was declared with
            //    NotifierProvider.autoDispose, so once nothing is watching it
            //    (you leave ToggleScreen), its state is thrown away. Come
            //    back later and build() runs again -> fresh state (OFF).
            //    Riverpod equivalent of day_98's screen-scoped BlocProvider
            //    disposing its ToggleBloc on pop — but achieved purely by a
            //    FLAG on the provider declaration, not by WHERE you place a
            //    provider widget (there is no provider widget to place;
            //    toggleProvider is still just a top-level variable).
            // ================================================================
            const _Title('6) Navigation (shared bloc state)'),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetailsScreen()),
              ),
              child: const Text('Go to Details (same counter)'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ToggleScreen()),
              ),
              child: const Text('Go to Toggle (autoDispose provider)'),
            ),

            // ================================================================
            // 7) Navigate via provider (event-like pattern)
            //
            //    Instead of calling Navigator.push directly, this button
            //    calls ref.read(navProvider.notifier).requestToggleScreen(),
            //    which just sets navProvider's state to
            //    NavSignal.toggleScreen (then resets it to null). The
            //    ref.listen<NavSignal?> registered at the very top of this
            //    build() method reacts to that state change and performs the
            //    actual Navigator.push — navigation as a SIDE EFFECT of a
            //    state change, mirroring day_98's NavBloc pattern. This is
            //    overkill for a plain "open a screen" button (section 6's
            //    direct Navigator.push is simpler) — it earns its keep when
            //    navigation needs to happen only after some async result
            //    completes.
            // ================================================================
            const _Title('7) Navigate via provider (event → listener)'),
            ElevatedButton(
              onPressed: () =>
                  ref.read(navProvider.notifier).requestToggleScreen(),
              child: const Text('Go to Toggle (via provider signal)'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tiny helper so each section's heading looks consistent — same name and
/// shape as day_98's `_Title` helper widget, on purpose.
class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
