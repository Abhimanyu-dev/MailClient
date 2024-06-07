import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

class Mail extends StatelessWidget{
  const Mail({super.key, required this.mail});
  final MimeMessage mail;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.delete_outline_rounded),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.mark_email_unread_outlined),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            
            
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                
                child: Text("${mail.decodeSubject()}", textScaler: TextScaler.linear(2), textAlign: TextAlign.left,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("From: ${mail.from}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${mail.decodeTextPlainPart()}"),
              )
            ],
          ),
        ),
      )
    );
  }
}