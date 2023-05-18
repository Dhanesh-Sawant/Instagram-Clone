import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/Resources/auth_methods.dart';
import 'package:instagram_flutter/Screens/login_screen.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:instagram_flutter/Utils/utils.dart';
import 'package:instagram_flutter/Widgets/text_field.dart';

import '../Responsive/responsive_layout.dart';



class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  static String PageRoute = 'SignUp';

  @override
  State<SignUp> createState() => _SignUpState();
}



class _SignUpState extends State<SignUp> {

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }



  void selectImage() async {

    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
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
                    Flexible(child: Container(),flex: 2),
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),
                    SizedBox(height: 12),
                    // circle avatar for profile pic
                    Stack(
                      children: [
                        _image!=null ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!)
                        )
                        :
                        const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2w35-ywQxAxsVTPs5rHEF2m0b_CBnLHJNgA&usqp=CAU',
                          ),
                        ),
                        Positioned(
                          child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(Icons.add_a_photo)
                          ),
                          bottom: -10,
                          left: 80,
                        )
                      ],
                    ),
                    SizedBox(height: 24),

                    InputTextField(
                      hintText: 'Enter your Username here..',
                      textinputType: TextInputType.text,
                      textEditingController: _usernameController,
                    ),
                    SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    InputTextField(
                      hintText: 'Enter your Bio here..',
                      textinputType: TextInputType.text,
                      textEditingController: _bioController,
                    ),


                    SizedBox(height: 24),
                    MaterialButton(
                      onPressed: () async {

                        setState(() {
                          _isLoading = true;
                        });

                        String result = await AuthMethods().SignUpUser(
                            username: _usernameController.text,
                            email: _emailEditingController.text,
                            password: _passwordEditingController.text,
                            bio: _bioController.text,
                            file: _image,
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
                      child: _isLoading! ? Center(child: CircularProgressIndicator(color: Colors.white,)) : Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, LoginScreen.PageRoute);
                          },
                          child: Container(
                            child: Text(
                                'Log in',
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
