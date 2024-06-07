import 'dart:convert';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mail_client/backend/mail_validation.dart';
import 'package:mail_client/models/user_model.dart';
import 'package:mail_client/ui/mail.dart';

class SendPage extends StatefulWidget {

  SendPage({super.key});

  Box<User> localDB = Hive.box<User>("local_db");
  late SmtpClient smtpClient;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {

  final TextEditingController email = TextEditingController();
  final TextEditingController subject = TextEditingController();
  final TextEditingController body = TextEditingController();

  Future<void> init() async{
    widget.smtpClient = SmtpClient("enough.de");
    await validateSmtp(widget.smtpClient, widget.localDB.getAt(0)!.username, widget.localDB.getAt(0)!.password);
  }
  @override
  void initState(){
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  FloatingActionButton(
              onPressed: () async {
                final builder = MessageBuilder.prepareMultipartAlternativeMessage(
                  plainText: body.text,
                  htmlText: "<p>${body.text}</p>",
                  transferEncoding: TransferEncoding.eightBit
                )..from = [MailAddress(widget.localDB.getAt(0)!.username, "${widget.localDB.getAt(0)!.username}@iitk.ac.in")]
                ..to = [MailAddress(email.text, email.text)]
                ..subject = subject.text;
                try{
                final mimeMessage = builder.buildMimeMessage();
                // ignore: unused_local_variable
                final sendResponse = await widget.smtpClient.sendMessage(mimeMessage);
                print(sendResponse.message);
                await showDialog(context: context, builder: (BuildContext context) => const AlertDialog(
                                      title: Text("Mail Sent"),
                                    ));
                } catch (error) {
                  showDialog(context: context, builder: (BuildContext context) => const AlertDialog(
                                      title: Text("Something Went Wrong"),
                                    ));
                }
              },
              child: const Icon(Icons.send),
            ),
      appBar: AppBar(
        title: const Text('Draft'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {},
              title: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: email,
                            decoration: const InputDecoration(
                              hintText: "To: email address",
                              border: InputBorder.none,
                            ),
                          ),
                        ),  
                      ],
                    ),
            ),
            
              TextField(
                controller: subject,
                decoration: const InputDecoration(
                  hintText: "Subject",
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: body,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
            ]
          
        ),
      ),
    );
  }
}