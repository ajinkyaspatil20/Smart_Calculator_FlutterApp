import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _role = '';
  String _mathInterest = '';
  String _difficultyLevel = '';
  String _favoriteMathField = '';
  String? _profileImagePath;

  // SharedPreferences keys
  static const String _usernameKey = 'username';
  static const String _roleKey = 'role';
  static const String _mathInterestKey = 'mathInterest';
  static const String _difficultyLevelKey = 'difficultyLevel';
  static const String _favoriteMathFieldKey = 'favoriteMathField';
  static const String _profileImagePathKey = 'profileImagePath';

  UserProvider() {
    _loadUserData();
  }

  // Getters
  String get username => _username;
  String get role => _role;
  String get mathInterest => _mathInterest;
  String get difficultyLevel => _difficultyLevel;
  String get favoriteMathField => _favoriteMathField;
  String? get profileImagePath => _profileImagePath;

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString(_usernameKey) ?? '';
      _role = prefs.getString(_roleKey) ?? '';
      _mathInterest = prefs.getString(_mathInterestKey) ?? '';
      _difficultyLevel = prefs.getString(_difficultyLevelKey) ?? '';
      _favoriteMathField = prefs.getString(_favoriteMathFieldKey) ?? '';
      _profileImagePath = prefs.getString(_profileImagePathKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
      // Set default values if loading fails
      _username = '';
      _role = '';
      _mathInterest = '';
      _difficultyLevel = '';
      _favoriteMathField = '';
      _profileImagePath = null;
    }
  }

  Future<void> updateUserData({
    String? username,
    String? role,
    String? mathInterest,
    String? difficultyLevel,
    String? favoriteMathField,
    String? profileImagePath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (username != null) {
        _username = username;
        await prefs.setString(_usernameKey, username);
      }
      if (role != null) {
        _role = role;
        await prefs.setString(_roleKey, role);
      }
      if (mathInterest != null) {
        _mathInterest = mathInterest;
        await prefs.setString(_mathInterestKey, mathInterest);
      }
      if (difficultyLevel != null) {
        _difficultyLevel = difficultyLevel;
        await prefs.setString(_difficultyLevelKey, difficultyLevel);
      }
      if (favoriteMathField != null) {
        _favoriteMathField = favoriteMathField;
        await prefs.setString(_favoriteMathFieldKey, favoriteMathField);
      }
      if (profileImagePath != null) {
        _profileImagePath = profileImagePath;
        await prefs.setString(_profileImagePathKey, profileImagePath);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user data: $e');
      // Revert changes if saving fails
      await _loadUserData();
      throw Exception('Failed to save user data');
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_mathInterestKey);
    await prefs.remove(_difficultyLevelKey);
    await prefs.remove(_favoriteMathFieldKey);
    await prefs.remove(_profileImagePathKey);

    _username = '';
    _role = '';
    _mathInterest = '';
    _difficultyLevel = '';
    _favoriteMathField = '';
    _profileImagePath = null;

    notifyListeners();
  }
}
