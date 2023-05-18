import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/search_screen.dart';
import '../Screens/post_screen.dart';
import '../Screens/feed_screen.dart';
import '../Screens/profile_screen.dart';

const webscreensize = 600;

List<Widget> homeScreenItems = [

  FeedScreen(),
  SearchScreen(),
  PostScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
