import 'package:chat_app/components/post.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   //sign user out
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  //user 
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();
  final nameTextController = TextEditingController();

  //post message
  void postMessage(){
    //only post if there is something in the textfield
    if(textController.text.isNotEmpty){
      //store post in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'name': nameTextController.text,
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
    });
    }
  
  
  //clear the textfield
  setState(() {
    textController.clear();
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 187, 221),
        body:  Center(
          child: Column(
            children: [
              //Yize
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy(
                    "TimeStamp",
                    descending: false,
                  )
                  .snapshots(), 
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          final post = snapshot.data!.docs[index];
                          return Post(
                            message: post['Message'], 
                            user: post['UserEmail'],
                            );
                        });
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
                  ),

              //post something
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    //textfield
                    Expanded(
                      child: MyTextField(
                        controller: textController, 
                        hintText: 'Write something to post..', 
                        obscureText: false,
                        )
                        ),
              
                    //post button
                    IconButton(
                      onPressed: postMessage, 
                      icon: const Icon(Icons.arrow_circle_up))
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}