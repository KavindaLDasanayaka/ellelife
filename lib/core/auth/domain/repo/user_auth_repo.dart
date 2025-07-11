import 'package:firebase_auth/firebase_auth.dart';

abstract class UserAuthRepo {
  User? getCurrentUser();
  Future<void> signOut();
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithGoogle();
}
