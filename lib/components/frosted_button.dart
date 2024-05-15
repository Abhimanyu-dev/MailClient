import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedButton extends StatelessWidget {
  const FrostedButton({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 50,
              width: 350,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade200.withOpacity(0.2)
              ),
              child: child,
            
            ),
          ),
        ),
      ),
    );
  }
}