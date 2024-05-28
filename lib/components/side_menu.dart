import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget{
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(title: const Text("Inbox"), onTap: () {Navigator.pop(context);}),
            ListTile(title: const Text("Inbox"), onTap: () {Navigator.pop(context);}),
            ListTile(title: const Text("Inbox"), onTap: () {Navigator.pop(context);}),
            ListTile(title: const Text("Inbox"), onTap: () {Navigator.pop(context);}),
            ListTile(title: const Text("Inbox"), onTap: () {Navigator.pop(context);}),
          ],
        ),
      ),
    );
  }
}