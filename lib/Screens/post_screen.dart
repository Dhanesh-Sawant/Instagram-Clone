import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/Providers/user_provider.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:instagram_flutter/Utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../Models/Users.dart';
import '../Resources/firestore_methods.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  Uint8List? _file;
  TextEditingController DescriptionController = TextEditingController();
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  bool isLoading = false;


  void postImage(
      String UID,
      String Username,
      String ProfileImg, // imageid
  )async{

    setState(() {
      isLoading = true;
    });

    try{

      String result = await _fireStoreMethods.uploadPost(
        DescriptionController.text,
        _file!,
        UID,
        Username,
        ProfileImg
      );

      if(result=="Success"){
        setState(() {
          isLoading = false;
        });
        showSnackBar('Posted!!', context);
        setState(() {
          _file = null;
        });
      }
      else{
        showSnackBar(result, context);
        setState(() {
          isLoading = false;
        });
      }

    }
    catch(err){
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }

  }


  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Take a Photo'),
                  onPressed: ()async{
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Choose Image From Gallery'),
                  onPressed: ()async{
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Cancel'),
                  onPressed: ()async{
                    Navigator.of(context).pop();
                  }
              ),
            ],
          );
        }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    DescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return _file==null ?

    Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: () {
          return _selectImage(context);
        },
      ),
    )

    :

    Scaffold(
      appBar: AppBar(
        title: Text('Post to'),
        leading: IconButton(
          onPressed: (){
            setState(() {
              _file = null;
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: mobileBackgroundColor,
        actions: [
          TextButton(
              onPressed: () => postImage(user.uid,user.username,user.picUrl),
              child: Text(
                'Post',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
          )
        ],
      ),
      body: Column(
        children: [

          Column(
            children: [
              isLoading? LinearProgressIndicator() : Container(),
              SizedBox(height: 20),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.picUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: DescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Give a Caption...',
                    border: InputBorder.none
                  ),
                  maxLines: 8,
                ),
              ),

              SizedBox(
                width: 50,
                height: 45,
                child: AspectRatio(
                  aspectRatio: 487/451, // aspect ratio used to keep the photo in aligned with the size of the box
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),

              )
            ],
          )
        ],
      )
    );
  }
}
