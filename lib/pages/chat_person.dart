import 'package:chat_app/chat/chat_service.dart';
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPerson extends StatefulWidget {
  final String name;
  final String receiverUserID;
  const ChatPerson({
    super.key,
    required this.name,
    required this.receiverUserID,
    });

  @override
  State<ChatPerson> createState() => _ChatPersonState();
}

class _ChatPersonState extends State<ChatPerson> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text);
        // clear the controller after sending
        _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      backgroundColor: Color.fromARGB(255, 168, 187, 221),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),

          const SizedBox(height: 25,),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(
      widget.receiverUserID, _firebaseAuth.currentUser!.uid), 
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        return ListView(
          children: snapshot.data!.docs
          .map((document) => _buildMessageItem(document))
          .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the message
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

      return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
            mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              :MainAxisAlignment.start,
            children: [
              //Text(data['senderEmail']),
              //const SizedBox(height: 5,),
              ChatBubble(message: data['message']),
            ],
          ),
        ),
      );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController, 
              hintText: 'Write a message', 
              obscureText: false,
              ),
              ),
    
              //send button
              IconButton(
                onPressed: sendMessage, 
                icon: const Icon(
                  Icons.send,
                  size: 40,
                  ),
              )
        ],
      ),
    );
  }

}