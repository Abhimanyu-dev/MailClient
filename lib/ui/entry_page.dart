import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mail_client/components/frosted_button.dart';
import 'package:mail_client/ui/singin_page.dart';
import 'package:mail_client/animation/animation.dart';

class EntryPage extends StatelessWidget{
  final String title;

  const EntryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        
        body: Container(
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            children: [
              Title(),
              
              Buttons()
            ],
          ),
        ),
      );
    

  }
}



class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Center(
        child: Column(
          children: [
            FrostedButton(
              child: const Text("Sign In",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.of(context).push(RouteAnimation.createRoute(const SignInPage()));
              }
            ),
          ],),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Mail\nClient",
            style: GoogleFonts.playfairDisplay(
              textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60,
              letterSpacing: 0  ,
              height: 1.2,
              color: Colors.white,
              ),
            ),
              textAlign: TextAlign.center,
            )
          ),
      ),
    );
  }
} 

