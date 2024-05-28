import 'package:flutter/material.dart';
import 'package:mail_client/animation/animation.dart';
import 'package:mail_client/ui/mail.dart';

class MailTile extends StatelessWidget{
  const MailTile({super.key, required this.sender, required this.body});

  final Widget sender, body;

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
        title: sender,
        subtitle: body,
        onTap: () {
          Navigator.of(context).push(RouteAnimation.createRoute(const Mail()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const Icon(Icons.person),
      ),
    );
  }  
}