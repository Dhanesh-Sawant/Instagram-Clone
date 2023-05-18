import 'dart:typed_data';
import '../Models/Users.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/Resources/storage_methods.dart';


class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<model.User> getUserDetails() async {
    User currentuser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firestore.collection('Users').doc(currentuser.uid).get();
    return model.User.fromSnap(snapshot);
  }



  Future<String> SignUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List? file,
  }) async {
      String result = "some error";
      try{
        if(username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && bio.isNotEmpty && file!=null)
          {
            UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
            print(cred.user!.uid);

            // get download url of profile pic from storage methods
            String picUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

            model.User user = model.User(
              username: username,
              uid : cred.user!.uid,
              email : email,
              bio : bio,
              followers : [],
              following : [],
              picUrl : picUrl,
            );

            await _firestore.collection('Users').doc(cred.user!.uid).set(user.toJson());

            // await _firestore.collection('Users').add({
            //   'username': username,
            //   'uid' : cred.user!.uid,
            //   'email' : email,
            //   'bio' : bio,
            //   'followers' : [],
            //   'following' : []
            // });

            result = 'success';
          }
        else {
          result = 'Enter all the details';
        }
      }
      // on FirebaseAuthException catch(err){
      //   if(err.code == 'invalid-email'){
      //     result = 'The email address is badly formatted';
      //   }
      //   if(err.code == 'weak-password'){
      //     result = 'Password should be at least 6 characters';
      //   }
      // }
      catch(e){
        result = e.toString();
      }
    return result;
  }


    Future<String> LoginInUser({
      required String email,
      required String password
  })async{
      String result = "some error";

      try{

        if(email.isNotEmpty && password.isNotEmpty){
          UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
          result="success";
        }
        else result="Enter all info!!";

      }catch(err) {
        result = err.toString();
      }
      return result;
}

    Future<void> SignOut() async{

     await _auth.signOut();
  }


}