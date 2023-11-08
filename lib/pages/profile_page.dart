import 'package:chat_app/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //user 
  final currentUser = FirebaseAuth.instance.currentUser;

  //edit field
  Future<void> editField(String field) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 187, 221),
      body:  ListView(
              children: [
                const SizedBox(height:50),
                //profile pic
                const Icon(
                  Icons.person,
                  size: 70,
                  ),
                const SizedBox(height:10),
                //user email
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height:10),
                //user details
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'My profile',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  ),

                //name
                MyTextBox(
                  text: 'name', 
                  sectionName: 'name',
                  onPressed: () => editField('name'),
                  ),

                //bio
                MyTextBox(
                  text: 'bio', 
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                  ),

                //user posts

              ],
     ) );
  }
}