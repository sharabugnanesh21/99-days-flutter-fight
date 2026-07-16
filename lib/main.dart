import 'package:basic_app/day_97/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:basic_app/day_98/counter_bloc/counter_bloc.dart';
// import 'package:basic_app/day_98/repository/user_repository.dart';
// import 'package:basic_app/day_98/screens/home_screen.dart';
// import 'package:basic_app/day_98/user/user_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  /// day[99] 📙
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // runApp(MaterialApp(home: Scaffold(body: LoginPage())));

  /// day[98] 📙 — flutter_bloc demo.
  // Everything is provided ABOVE MaterialApp so every screen you navigate to
  // can still reach the same blocs/repositories.
  // runApp(
  //   // RepositoryProvider — exposes the data layer (repositories) to the tree.
  //   RepositoryProvider(
  //     create: (_) => UserRepository(),

  //     // MultiBlocProvider — shorthand for nesting several BlocProviders.
  //     child: MultiBlocProvider(
  //       providers: [
  //         // BlocProvider — creates ONE bloc, shared with everything below.
  //         BlocProvider(create: (_) => CounterBloc()),

  //         // This bloc needs the repository, so we read it from context.
  //         BlocProvider(
  //           create: (context) => UserBloc(context.read<UserRepository>()),
  //         ),
  //       ],

  //       // MaterialApp sits BELOW the providers -> every route can reach them.
  //       child: const MaterialApp(
  //         debugShowCheckedModeBanner: false,
  //         home: HomeScreen(),
  //       ),
  //     ),
  //   ),
  // );

  /// day[97] 📙 — riverpod demo.
  // Notice how much SHORTER this is than day_98's block above: there is no
  // list of providers to register here at all. Every provider (counter,
  // toggle, user, nav, repository) is declared ONCE as a global top-level
  // variable in its own file (see lib/day_97/*/*.dart) — ProviderScope alone
  // is what makes ALL of them reachable via ref.watch/ref.read anywhere below
  // it. Compare with day_98's MultiBlocProvider, which had to explicitly list
  // every bloc it wanted to share.
  runApp(
    // ProviderScope — the ONE required root wrapper for any Riverpod app.
    // Without it, ref.watch/ref.read throw "no ProviderScope found".
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    ),
  );
}
