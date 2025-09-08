import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellelife/core/auth/domain/repo/user_auth_repo.dart';
import 'package:ellelife/core/exceptions/firebase_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthService extends UserAuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //This methode will sign out the user and print a message to the console
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  //This methode will return the current user , here the user is the one that is signed in and fierbase will return the user and we can use it to get the user data (uid, email...)
  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //create user with email and password
  //This methode will create a new user with email and password and return the user credential
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //sign in with email and password
  //This methode will sign in the user with email and password
  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  //sign in with google
  //This methode will sign in the user with google
  @override
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the GoogleSignInAuthentication object
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Prepare user data
        final userData = {
          'userId': user.uid,
          'name': user.displayName ?? 'No Name',
          'email': user.email ?? 'No Email',
          'teamName': '',
          'imageUrl': user.photoURL ?? '',
          'createdAt': Timestamp.fromDate(DateTime.now()),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
          'password': '', // Password is not needed for Google sign-in
          'followers': 0,
        };

        // Save user to Firestore
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        await userDocRef.set(userData);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      // Validate email format
      if (email.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        throw Exception("Please enter a valid email address");
      }

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception("Failed to send password reset email. Please try again.");
    }
  }
}
