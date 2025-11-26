import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update(updatedUser.toJson());
      } else {
        throw Exception("No user logged in");
      }
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  Future<void> requestVendor() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (!doc.exists) throw Exception("User not found");

        final userModel = UserModel.fromMap(doc.data()!, user.uid);
        final updatedUser = userModel.copyWith(
          vendorRequest: true,
          vendorStatus: 'pending',
        );

        await docRef.update(updatedUser.toJson());
      } else {
        throw Exception("No user logged in");
      }
    } catch (e) {
      throw Exception("Failed to send vendor request: $e");
    }
  }

  Future<String?> getUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      print("Error getting user role: $e");
      return null;
    }
  }
  Future<UserModel?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    print("==========================");
    print("Current UID: ${user.uid}");
    print("==========================");

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, user.uid);
    }
    return null;
  }

}
