import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();


// sign user in
void signIn() async {
  //  get the auth service
  final authService = Provider.of<AuthService>(context,listen: false);

  try {
    await authService.signInWithEmailAndPassword(
      emailTextController.text, 
      passwordTextController.text,);
  } catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
        )
        );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 187, 221),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

              children: [
                  
                  
                  //Logo
                  const Icon(
                    Icons.person,
                    size: 100,
                    ),
                  
                  const SizedBox(height: 20),
                  //Welcome
                  Text(
                    'Welcome to Yize chatApp',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                    ),
                
                  const SizedBox(height: 50),
                  //email textfield
                  MyTextField(
                    controller: emailTextController, 
                    hintText: 'Email', 
                    obscureText: false,
                    ),

                  //password textfield
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: passwordTextController, 
                    hintText: 'Password', 
                    obscureText: true,
                    ),

                  //sign in button
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: signIn, 
                    text: 'Sign In',
                    ),

                  //not a member ? Register now
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      ),
                      const SizedBox(width: 4,),

                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          ),
                      )
                    ],
                  )
            ],),
          ),
        ),
      ),
    );
  }
}