import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = 'Some error occure';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // model.User _user = model.User(
        //   username: username,
        //   uid: cred.user!.uid,
        //   photoUrl: photoUrl,
        //   email: email,
        //   bio: bio,
        //   followers: [],
        //   following: [],
        // );
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'photoUrl': photoUrl,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
        });
      }
      res = 'success';
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
    return res;
  }
}
