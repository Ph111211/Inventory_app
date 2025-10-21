import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
  Stream<User?> get authStateChanges;
}