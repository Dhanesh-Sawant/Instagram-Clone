import 'package:flutter/material.dart';
import 'package:instagram_flutter/Resources/auth_methods.dart';
import 'package:instagram_flutter/Models/Users.dart';


class UserProvider with ChangeNotifier {

  late User _user;
  final AuthMethods _authMethods = AuthMethods(); // instance of authmethods to get to its methods

  User get getUser => _user;

    Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}