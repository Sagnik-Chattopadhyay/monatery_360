import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _user = _authService.currentUser;
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isLocal => _user?.isLocal ?? false;
  bool get isTourist => _user?.isTourist ?? true;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.login(email, password);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _user != null;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? monasteryAffiliation,
    bool hasAsthma = false,
    bool hasHeartCondition = false,
    bool hasAltitudeSensitivity = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
        monasteryAffiliation: monasteryAffiliation,
        hasAsthma: hasAsthma,
        hasHeartCondition: hasHeartCondition,
        hasAltitudeSensitivity: hasAltitudeSensitivity,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _user != null;
  }

  Future<void> updateHealthProfile({
    required bool hasAsthma,
    required bool hasHeartCondition,
    required bool hasAltitudeSensitivity,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.updateHealthProfile(
        hasAsthma: hasAsthma,
        hasHeartCondition: hasHeartCondition,
        hasAltitudeSensitivity: hasAltitudeSensitivity,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}

