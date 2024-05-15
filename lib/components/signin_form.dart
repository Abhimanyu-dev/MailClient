import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mail_client/animation/animation.dart';
import 'package:mail_client/components/input.dart';
import 'package:mail_client/ui/mail_list.dart';

class SignInForm extends StatefulWidget{
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  @override
  Widget build(BuildContext context){
    return Expanded(
                flex: 7,
                child: ClipRect(
                  child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1 ),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withOpacity(0.09)
                    ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("Enter your login information", style: TextStyle(color: Colors.white38, fontSize: 20),),
                          ),
                          const Input(icon: Icon(Icons.mail_outline_outlined), label: "Email", isPassword: false,),
                          const Input(icon: Icon(Icons.lock_outlined), label: "Password", isPassword: true,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                  )
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(RouteAnimation.createRoute(const MailList()));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20),),
                                )
                                ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              );
  }
}
