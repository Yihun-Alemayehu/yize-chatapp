import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

void signUp() async {
  if(passwordTextController.text != confirmPasswordTextController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("passwords don't match"),
        )
      );
      return;
  }

  //get auth service
  final authService = Provider.of<AuthService>(context, listen: false);

  try {
    await authService.signUpWithEmailAndPassword(
      emailTextController.text, 
      passwordTextController.text,
      nameTextController.text,
      );
  } catch (e) {
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
                    'Lets create an account for you',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                    ),
                
                   const SizedBox(height: 50),
                  //name textfield
                  MyTextField(
                    controller: nameTextController, 
                    hintText: 'Name', 
                    obscureText: false,
                    ),


                  const SizedBox(height: 20),
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

                  //Confirm password textfield
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: confirmPasswordTextController, 
                    hintText: 'Confirm Password', 
                    obscureText: true,
                    ),


                  //sign up button
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: signUp, 
                    text: 'Sign Up',
                    ),

                  //Already have an account ? Sign In
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account ?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      ),
                      const SizedBox(width: 4,),

                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign In",
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