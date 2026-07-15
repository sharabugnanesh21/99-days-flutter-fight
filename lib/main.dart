import 'package:basic_app/day_98/counter_bloc/counter_bloc.dart';
import 'package:basic_app/day_98/repository/user_repository.dart';
import 'package:basic_app/day_98/screens/home_screen.dart';
import 'package:basic_app/day_98/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// day_98 — flutter_bloc demo.
// Everything is provided ABOVE MaterialApp so every screen you navigate to can
// still reach the same blocs/repositories.
void main() {
  /// day[99] 📙
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // runApp(MaterialApp(home: Scaffold(body: LoginPage())));

  /// day[98] 📙
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

  /// day[97] 📙
}
