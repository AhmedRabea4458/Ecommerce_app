import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';
import '../utils/translate_error.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<UserCredential> signUp(String email, String password,
      String userName) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser.user != null) {
        await newUser.user!.updateDisplayName(userName);

        final userModel = UserModel(
          name: userName,
          email: email,
          image: '',
          uid: newUser.user!.uid,
        );

        await _firestore.collection('users').doc(newUser.user!.uid).set(
            userModel.toJson());

        try {
          await newUser.user!.sendEmailVerification();
          print("Verification email sent to ${newUser.user!.email}");
        } catch (error) {
          print("Error sending email verification: $error");
        }      }

      return newUser;
    } catch (e) {
      throw Exception(translateFirebaseError(e.toString()));
    }
  }

  Future<UserModel?> logIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          return null;
        }

        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data()!, user.uid);
        } else {
          final userModel = UserModel(
            uid: user.uid,
            name: email.split('@')[0],
            email: email,
            image: '',
          );

          await _firestore.collection('users').doc(user.uid).set(
            userModel.toJson(),
            SetOptions(merge: true),
          );

          return userModel;
        }
      }
      return null;
    } catch (e) {
      throw Exception(translateFirebaseError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
    }
  }


}

