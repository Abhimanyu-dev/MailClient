import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    super.key, required this.icon, required this.label, required this.isPassword
  });

  final bool isPassword;
  final Icon icon;
  final String label;


  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {

  late bool obscure;

  @override
  void initState(){
    obscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 18),
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          suffixIcon: widget.isPassword ? 
            IconButton(
              onPressed: (){
              setState(() {
                obscure = !obscure;
              });
            }, 
            icon: obscure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
            ) : 
            null
          ,
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
          
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.white),
          
        ),
      ),
    );
  }
}