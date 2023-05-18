import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Providers/user_provider.dart';
import 'package:instagram_flutter/Responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/Responsive/web_screen_layout.dart';
import 'package:instagram_flutter/Utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({Key? key}) : super(key: key);

  static String PageRoute = 'ResponsiveLayout';

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}


class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  Future<void> addData() async {
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxWidth > webscreensize){
            return WebScreenLayout();
          }
          else {
            return MobileScreenLayout();
          }
        }
    );
  }
}
