import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mail_client/components/signin_form.dart';

class SignInPage extends StatelessWidget{
  const SignInPage({super.key});

  @override

  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child:  Center(
          child: Column(
            children: [
              Expanded(
                flex: 3 ,
                child: Center(
                  child: Text(
                  "LOGIN",
                  style: GoogleFonts.playfairDisplay(
                  textStyle: const TextStyle(
                    fontSize: 45,
                    letterSpacing: 0  ,
                    height: 1.2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                    textAlign: TextAlign.center,
                  ),
                )
              ),
              const SignInForm(),
            ],
          ),
        ),
      ),

    );
  }
}