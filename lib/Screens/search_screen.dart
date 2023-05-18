import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Screens/profile_screen.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user'
          ),
          onFieldSubmitted: (String _){
            print(_);
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),

      body: isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('Users')
            .where('username',isGreaterThanOrEqualTo:_searchController.text)
            .get(),
        builder: (context,snapshot){

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid']))),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['picUrl']
                      ),
                    ),
                    title: Text((snapshot.data! as dynamic).docs[index]['username']),
                  ),
                );
              }
          );

        },
      )
          :
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('Posts').get(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                      fit: BoxFit.cover,
                    ),

                );

                // return StaggeredGridView.countBuilder(
                //   crossAxisCount: 3,
                //   itemCount: (snapshot.data! as dynamic).docs.length,
                //   itemBuilder: (context, index) => Image.network(
                //     (snapshot.data! as dynamic).docs[index]['postUrl'],
                //     fit: BoxFit.cover,
                //   ),
                //   staggeredTileBuilder: (index) => MediaQuery.of(context)
                //       .size
                //       .width >
                //       webScreenSize
                //       ? StaggeredTile.count(
                //       (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                //       : StaggeredTile.count(
                //       (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                //   mainAxisSpacing: 8.0,
                //   crossAxisSpacing: 8.0,
                // );

              }
          )




    );
  }
}
