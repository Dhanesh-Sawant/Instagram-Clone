import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  final String username;
  final String uid;
  final String email;
  final String bio;
  final String picUrl;
  final List following;
  final List followers;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.picUrl,
    required this.following,
    required this.followers,
});

  Map<String,dynamic> toJson() => {
    'username': username,
    'uid' : uid,
    "email" : email,
    'bio' : bio,
    'picUrl' : picUrl,
    'following' : following,
    'followers' : followers,
  };


   // take user snapshot and return user model
  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      picUrl: snapshot['picUrl'],
      following: snapshot['following'],
      followers: snapshot['followers'],
    );
  }

}

