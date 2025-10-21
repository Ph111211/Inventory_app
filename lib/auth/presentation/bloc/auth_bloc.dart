import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends ChangeNotifier {
  final AuthService _authService;
  
  AuthBloc({required AuthService authService}) : _authService = authService {
    _initializeAuthListener();
  }

  AuthState _state = AuthInitial();
  AuthState get state => _state;

  StreamSubscription<User?>? _authSubscription;

  void _emit(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void add(AuthEvent event) {
    if (event is LoginRequested) {
      _onLoginRequested(event);
    } else if (event is LogoutRequested) {
      _onLogoutRequested();
    } else if (event is AuthStatusChanged) {
      _onAuthStatusChanged(event);
    }
  }

  void _initializeAuthListener() {
    _authSubscription = _authService.authStateChanges.listen(
      (user) => add(AuthStatusChanged(user)),
    );
  }

  void _onLoginRequested(LoginRequested event) async {
    _emit(AuthLoading());
    
    try {
      final user = await _authService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      if (user != null) {
        _emit(AuthAuthenticated(user));
      } else {
        _emit(const AuthError('Đăng nhập thất bại'));
      }
    } catch (e) {
      _emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onLogoutRequested() async {
    try {
      await _authService.signOut();
      _emit(AuthUnauthenticated());
    } catch (e) {
      _emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onAuthStatusChanged(AuthStatusChanged event) {
    if (event.user != null) {
      _emit(AuthAuthenticated(event.user!));
    } else {
      _emit(AuthUnauthenticated());
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}