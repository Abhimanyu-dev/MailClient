import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:mail_client/animation/animation.dart';
import 'package:mail_client/backend/mail_validation.dart';
import 'package:mail_client/models/email_model.dart';
import 'package:mail_client/ui/mail.dart';

class MailTile extends StatelessWidget{
  const MailTile({super.key, required this.mail, required this.imapClient});

  final Email mail;
  final ImapClient imapClient;

  @override
  Widget build(BuildContext context){
    return Container(
      height: 75,
      width: double.infinity,
      // padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(  
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12)
      ),
      alignment: Alignment.topLeft,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(mail.sender, overflow: TextOverflow.ellipsis,),
        ),
        subtitle: Text(mail.subject, overflow: TextOverflow.ellipsis,),
        onTap: () async {
          int id = mail.uid!;
          var email = await imapClient.fetchMessage(id, "(FLAGS BODY[])");
          
          Navigator.of(context).push(RouteAnimation.createRoute(Mail(mail: email.messages[0])));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const Icon(Icons.person),
      ),
    );
  }  
}