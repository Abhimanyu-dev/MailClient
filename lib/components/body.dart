import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({
    super.key
  });


  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  late bool obscure;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 18),
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          filled:true,
          fillColor: Colors.transparent,
          enabledBorder:  OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white38),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue ),
            borderRadius: BorderRadius.circular(20)
          ),
          
          labelText: "Body",
          labelStyle: const TextStyle(color: Colors.white),
          
        ),
      ),
    );
  }
}