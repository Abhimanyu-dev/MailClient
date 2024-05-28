import 'package:flutter/material.dart';

class Mail extends StatelessWidget{
  const Mail({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        actions: const [
          Icon(Icons.delete_outline_rounded),
          Icon(Icons.mark_email_unread_outlined),
          Icon(Icons.more_vert)
        ],
      ),
    );
  }
}