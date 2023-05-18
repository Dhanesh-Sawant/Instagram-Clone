import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/Resources/auth_methods.dart';
import 'package:instagram_flutter/Responsive/responsive_layout.dart';
import 'package:instagram_flutter/Screens/Sign_up_screen.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:instagram_flutter/Widgets/text_field.dart';

import '../Utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String PageRoute = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: CustomScrollView(
            slivers: [

              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Container(),flex: 1),
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),

                    SizedBox(height: 64),
                    InputTextField(
                      hintText: 'Enter your E-Mail here..',
                      textinputType: TextInputType.emailAddress,
                      textEditingController: _emailEditingController,
                    ),
                    SizedBox(height: 16),
                    InputTextField(
                      hintText: 'Enter your Password here..',
                      textinputType: TextInputType.visiblePassword,
                      textEditingController: _passwordEditingController,
                      isPass: true,
                    ),
                    SizedBox(height: 24),
                    MaterialButton(
                      onPressed: ()async{

                        setState(() {
                          _isLoading = true;
                        });

                        String result = await AuthMethods().LoginInUser(
                            email: _emailEditingController.text,
                            password: _passwordEditingController.text
                        );

                        print(result);

                        setState(() {
                          _isLoading = false;
                        });

                        if(result!='success'){
                          showSnackBar(result, context);
                        }
                        else {
                          Navigator.pushNamed(context, ResponsiveLayout.PageRoute);
                        }
                      },
                      color: blueColor,
                      minWidth: double.infinity,
                      child: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,)) : Text('Log in',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, SignUp.PageRoute);
                          },
                          child: Container(
                            child: Text(
                                'Sign up',
                                style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    Flexible(child: Container(),flex: 1),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
