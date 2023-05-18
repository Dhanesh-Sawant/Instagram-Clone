import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Providers/user_provider.dart';
import 'package:instagram_flutter/Screens/post_screen.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:instagram_flutter/Models/Users.dart' as model;

import '../Utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}


class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _pageNo = 0;
  // pagecontroller is the link between widget in the body to that of the bottombar


  late PageController pageController;

  void NavigationTapped(int page){
    pageController.jumpToPage(page); // pagecontroller will jump to page given and make the page view change
  }

  void onpageChanged(int page){
    setState(() {
      _pageNo = page;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: PageView(// pageview is what we see after we change by pagecontroller and it is indexed
          children: homeScreenItems,
          controller: pageController,
          onPageChanged: onpageChanged,
          physics: NeverScrollableScrollPhysics(), // to disable pageview by swiping left and right
          // onPageChanged: onPageChanged,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                color: _pageNo==0 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
                CupertinoIcons.search,
              color: _pageNo==1 ? primaryColor : secondaryColor,
              ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
                CupertinoIcons.add_circled,
              color: _pageNo==2 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.person,
              color: _pageNo==3 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          )
        ],
        onTap: NavigationTapped,
      ),
    );
  }
}
