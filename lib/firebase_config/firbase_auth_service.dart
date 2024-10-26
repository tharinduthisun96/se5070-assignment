import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

class FirebaseAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
//User registration
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update the display name after registration
      User? user = credential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload(); // Reload the user to apply changes
        user = auth.currentUser; // Refresh the current user
      }

      return user;
    } catch (e) {
      dev.log("--Firebase $e");
      return null;
    }
  }

//User Login
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      dev.log("--Firebase Login $e");
    }
  }
}
