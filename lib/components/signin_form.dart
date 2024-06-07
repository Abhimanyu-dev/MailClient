
import 'dart:ui';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mail_client/animation/animation.dart';
import 'package:mail_client/backend/mail_validation.dart';
import 'package:mail_client/components/input.dart';
import 'package:mail_client/models/email_model.dart';
import 'package:mail_client/models/user_model.dart';
import 'package:mail_client/ui/mail_list.dart';

class SignInForm extends StatefulWidget{
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  Box<User> localDb = Hive.box<User>('local_db');


  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState(){
    if(localDb.isNotEmpty){
    usernameController.text = localDb.getAt(0)!.username;
    passwordController.text = localDb.getAt(0)!.password;
    }
    super.initState();
  }


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                          Input(controller: usernameController, icon: const Icon(Icons.mail_outline_outlined), label: "Email", isPassword: false,),
                          Input(controller: passwordController, icon: const Icon(Icons.lock_outlined), label: "Password", isPassword: true,),
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
                                onPressed: () async {
                                  final imapClient = ImapClient(isLogEnabled: false);
                                  final user = usernameController.text;
                                  final password = passwordController.text;
                                  print(localDb.getAt(0)!.mails.length);
                                  if(localDb.isEmpty){
                                    bool isImapValid = await validateImap(imapClient, usernameController.text, passwordController.text);
                                    if(isImapValid){
                                      await imapClient.selectInbox();
                                      var result = await imapClient.fetchRecentMessages();
                                      List<Email> email_list = [];
                                      for(var message in result.messages){
                                        var newMail = Email("${message.fromEmail}", "${message.decodeSubject()}", message.sequenceId);
                                        email_list.add(newMail);
                                      }
                                      var newUser = User(user, email_list, password);
                                      localDb.add(newUser);
                                      Navigator.of(context).pushAndRemoveUntil(RouteAnimation.createRoute(MailList(imapClient: imapClient,)), (Route<dynamic> route) => false);
                                    }
                                  }
                                  else if(user == localDb.getAt(0)!.username){
                                      Navigator.of(context).pushAndRemoveUntil(RouteAnimation.createRoute(MailList(imapClient: ImapClient(isLogEnabled: false),)), (Route<dynamic> route) => false);
                                  }
                                  else{
                                    bool isImapValid = await validateImap(imapClient, usernameController.text, passwordController.text);
                                    if(isImapValid){
                                      await imapClient.selectInbox();
                                      var result = await imapClient.fetchRecentMessages();
                                      List<Email> email_list = [];
                                      for(var message in result.messages){
                                        print(message.sequenceId);
                                        var newMail = Email("${message.fromEmail}", "${message.decodeSubject()}", message.sequenceId);
                                        print(newMail.uid);
                                        email_list.add(newMail);
                                      }
                                      var newUser = User(user, email_list, password);
                                      localDb.add(newUser);
                                      Navigator.of(context).pushAndRemoveUntil(RouteAnimation.createRoute(MailList(imapClient: imapClient,)), (Route<dynamic> route) => false);
                                    }else{
                                      showDialog(context: context, builder: (BuildContext context) => const AlertDialog(
                                        title: Text("Invalid username or password"),
                                      ));
                                    }
                                  }
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
