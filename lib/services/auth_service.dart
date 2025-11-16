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
}
