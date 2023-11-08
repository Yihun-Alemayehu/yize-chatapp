import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/pages/chat_person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign user out
  void signOut(){
    //get auth service
    final authService = Provider.of<AuthService>(context,listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 187, 221),
      body: _buildUserList(),
    );
  }

  //build a list of users except for current user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(), 
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return const Text('Error');
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }

        return ListView(
          padding: const EdgeInsets.all(25),
          children: snapshot.data!.docs
            .map<Widget>((doc) => _buildUserListItem(doc))
            .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String,dynamic> data = document.data()! as Map<String,dynamic>;

    //display all users except current user
    if(_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          //pass the clicked user's UID to the chat page
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPerson(
                name: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }

}