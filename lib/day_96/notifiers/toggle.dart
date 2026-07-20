import 'package:flutter/foundation.dart';

class Toggle extends ChangeNotifier {
  bool _isOn = false;

  bool get isOn => _isOn;

  void toggle() {
    _isOn = !_isOn;
    notifyListeners();
  }
}
