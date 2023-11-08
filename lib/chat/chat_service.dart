import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // send message 
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a message
    Message newMessage =Message(
      senderId: currentUserId, 
      senderEmail: currentUserEmail, 
      receiverId: receiverId, 
      message: message, 
      timestamp: timestamp,
      );

    //construct chat room id from current user id and receiver id 
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_"); // combine ids into a single string


    //add new message to database
    await _fireStore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }

}