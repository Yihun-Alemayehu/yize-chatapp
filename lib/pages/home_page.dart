import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //sign user out
  void signOut(){
    //get auth service
    final authService = Provider.of<AuthService>(context,listen: false);

    authService.signOut();
  }

  final items = const [
    Icon(Icons.home, size: 30,),
    Icon(Icons.chat, size: 30,),
    Icon(Icons.person, size: 30,),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Center(child: Text("Yize")),
        actions: [
          //sign out button
          IconButton(
            onPressed: signOut, 
            icon: Icon(Icons.logout))

        ],
        ),
        
        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          index: index,
          onTap: (selectedIndex){
            setState(() {
            index = selectedIndex;
          });
          },
          height: 70,
          backgroundColor: Color.fromARGB(255, 168, 187, 221),
          //animationDuration: ,
          ),
            body: Container(
            color: Colors.blueAccent,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: getSelectedWidget(index: index)
      ),
    );
  }
    Widget getSelectedWidget({required int index}){
    Widget widget;
    switch(index){
      case 0:
        widget = const Home();
        break;
      case 1:
        widget = const ChatPage();
        break;
      default:
        widget = const Profile();
        break;
    }
    return widget;
  }
}


