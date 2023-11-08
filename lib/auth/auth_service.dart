import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   //instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sign user in 
  Future<UserCredential> signInWithEmailAndPassword(String email,String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
        );

      //add a new document for the user in users if it doesn't exists
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'name': nameTextController.text,
          'bio': 'Empty bio...',
        },SetOptions(merge: true));

        return userCredential;
    }
     // catch any errors
     on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }

  //create a new user
  Future<UserCredential>signUpWithEmailAndPassword(String email,password, String text) async {
    try {
      UserCredential userCredential = 
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, 
          password: password,
          );

        // after creating the user, create a new document for the user in user collection
        _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'name': nameTextController.text,
          'bio': 'Empty bio...',
        });

          return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }

  //sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}