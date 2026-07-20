import 'package:flutter/foundation.dart';

import 'user_state.dart';

class UserRepository {
  Future<List<String>> getUsers({bool fail = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (fail) throw Exception('Could not reach the server');
    return ['Alice', 'Bob', 'Charlie', 'Diana'];
  }
}

// Provider pattern: ChangeNotifier with state class
class User extends ChangeNotifier {
  final UserRepository repository;

  UserState _state = UserState();

  UserState get state => _state;

  User({required this.repository});

  Future<void> fetchUsers({bool simulateError = false}) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final users = await repository.getUsers(fail: simulateError);
      _state = _state.copyWith(isLoading: false, users: users, error: null);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, users: null, error: e.toString());
    }
    notifyListeners();
  }
}
