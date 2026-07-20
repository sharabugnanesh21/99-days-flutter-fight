import 'package:flutter/foundation.dart';

import 'counter_state.dart';

// Provider pattern: ChangeNotifier with state class (like day_98)
class Counter extends ChangeNotifier {
  CounterState _state = CounterState();

  CounterState get state => _state;

  void increment() {
    _state = _state.copyWith(count: _state.count + 1);
    notifyListeners();
  }

  void decrement() {
    _state = _state.copyWith(count: _state.count - 1);
    notifyListeners();
  }

  void reset() {
    _state = _state.copyWith(count: 0);
    notifyListeners();
  }
}
