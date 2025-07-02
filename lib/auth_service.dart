import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during signup: ${e.code} - ${e.message}");
      rethrow; // Important: Rethrow so the UI can handle it
    } catch (e) {
      log("Unexpected error during signup: $e");
      rethrow;
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during login: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      log("Unexpected error during login: $e");
      rethrow;
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error during signout: $e");
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await googleSignIn.signOut(); // Force account picker
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }
  //onboarding screen logic
  Future<void> markOnboardingComplete() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'onboardingComplete': true,
    }, SetOptions(merge: true)); // Merge to preserve other user data
  }
}
}
