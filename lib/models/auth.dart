import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  String firstName = '';
  String lastname = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('UserData');
  bool obscureText = false;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> getName(String emailId) async {
    try {
      final nameSnapshot =
          await Auth().users.where('EmailID', isEqualTo: emailId).get();
      if (nameSnapshot.docs.isEmpty) {
        ('No user found with email: $emailId');
      } else {
        for (var doc in nameSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          print(data['FirstName']);
          firstName = data['FirstName'];
          return data['FirstName'];
        }
      }
    } catch (e) {
      ('Error retrieving user: $e');
    }
    throw {("Error Fetching user")};
  }

  Future<String> getLastName(String emailId) async {
    try {
      final lastNameSnapshot =
          await Auth().users.where('EmailID', isEqualTo: emailId).get();
      if (lastNameSnapshot.docs.isEmpty) {
        ('No user found with email: $emailId');
      } else {
        for (var doc in lastNameSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          print(data['LastName']);
          lastname = data['LastName'];
          return data['LastName'];
        }
      }
    } catch (e) {
      ('Error retrieving user: $e');
    }
    throw {("Error Fetching user")};
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("Hello World"));
  }
}
