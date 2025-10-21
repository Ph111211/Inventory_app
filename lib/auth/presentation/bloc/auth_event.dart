import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final User? user;

  const AuthStatusChanged(this.user);
}