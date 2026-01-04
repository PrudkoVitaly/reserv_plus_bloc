import 'package:flutter/material.dart';

/// Контроллер для управления видимостью BottomNavigationBar
class BottomNavBarController extends ChangeNotifier {
  static final BottomNavBarController _instance = BottomNavBarController._internal();

  factory BottomNavBarController() => _instance;

  BottomNavBarController._internal();

  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
  }

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }
}
