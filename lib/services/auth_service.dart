/* import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  AuthService() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        _user = UserModel.fromFirestore(userDoc);
      } else {
        // Create user document if it doesn't exist
        await _createUserDocument(uid);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _createUserDocument(String uid) async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    _user = UserModel(
      uid: uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'Utilisateur',
      role: 'user',
      membershipDate: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(_user!.toFirestore());
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await _loadUserData(userCredential.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update user display name
      await userCredential.user!.updateDisplayName(name);

      // Create user document in Firestore
      _user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        role: 'user',
        membershipDate: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(_user!.toFirestore());

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Registration error: $e');
      return false;
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
*/

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  AuthService() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        _user = UserModel.fromFirestore(userDoc);
      } else {
        // Create user document if it doesn't exist
        await _createUserDocument(uid);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _createUserDocument(String uid) async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    _user = UserModel(
      uid: uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'Utilisateur',
      role: 'user',
      membershipDate: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(_user!.toFirestore());
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await _loadUserData(userCredential.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update user display name
      await userCredential.user!.updateDisplayName(name);

      // Create user document in Firestore
      _user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        role: 'user',
        membershipDate: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(_user!.toFirestore());

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Registration error: $e');
      return false;
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  // NEW: Refresh user data
  Future<void> refreshUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _loadUserData(user.uid);
    }
  }

  // NEW: Update user profile
  Future<bool> updateProfile(String name) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return false;

      // Update Firebase Auth display name
      await currentUser.updateDisplayName(name);

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'name': name, 'updatedAt': DateTime.now()});

      // Refresh local user data
      await _loadUserData(currentUser.uid);
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // NEW: Change password
  Future<bool> changePassword(String newPassword) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return false;

      await currentUser.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Password change error: $e');

      // Handle common errors
      if (e.code == 'requires-recent-login') {
        print('User needs to re-authenticate');
        // You could trigger re-authentication here
      }

      return false;
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }

  // NEW: Check if user is authenticated
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  // NEW: Get current Firebase User
  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  // NEW: Re-authenticate user (for sensitive operations)
  Future<bool> reauthenticate(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print('Reauthentication error: $e');
      return false;
    }
  }

  // NEW: Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // NEW: Update email
  Future<bool> updateEmail(String newEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      await user.verifyBeforeUpdateEmail(newEmail);

      // Update in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'email': newEmail, 'updatedAt': DateTime.now()},
      );

      return true;
    } catch (e) {
      print('Email update error: $e');
      return false;
    }
  }

  // NEW: Delete account
  Future<bool> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete from Firebase Auth
      await user.delete();

      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      print('Account deletion error: $e');
      return false;
    }
  }

  // NEW: Listen to auth state changes
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  // NEW: Get user token (for API calls)
  Future<String?> getUserToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final token = await user.getIdToken();
      return token;
    } catch (e) {
      print('Error getting user token: $e');
      return null;
    }
  }
}
