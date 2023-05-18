import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Providers/user_provider.dart';
import 'package:instagram_flutter/Responsive/responsive_layout.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Screens/Sign_up_screen.dart';
import 'Screens/login_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // ensures that all flutter widgets are initialised
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions( // from the web version when created from firebase
          apiKey: 'AIzaSyDDKrqKvWDoHRBLqJCKNxUJGRFUw0d_23M',
          appId: "1:773813698599:web:0f31a5303cc5975a4cce02",
          messagingSenderId: "773813698599",
          projectId: "instagram-clone-35fe5",
          storageBucket: "instagram-clone-35fe5.appspot.com",
      )
    );
  }
  else {
    await Firebase.initializeApp(); // initialises firebase app with mobile env
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // multiprovider since we use multiple providers
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()) // to get current user and to refresh user
      ],

      child: MaterialApp(

        routes: {
          LoginScreen.PageRoute : (context) => LoginScreen(),
          SignUp.PageRoute : (context) => SignUp(),
          ResponsiveLayout.PageRoute : (context) => ResponsiveLayout(),
        },

        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),  // checks only changes in login and logout
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){ // user has been authenticated and thus directly show them signed in screen
                return ResponsiveLayout();
              }
              else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'));
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            return LoginScreen(); // if snapshot.nodata then make user login
          },
        ),

        //ResponsiveLayout(),
      ),
    );
  }
}
