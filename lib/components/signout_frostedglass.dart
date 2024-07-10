import 'dart:ui';

import 'package:flutter/material.dart';

class SignoutFrostedGlass extends StatelessWidget {
  const SignoutFrostedGlass({
    this.thehight,
    this.thewidth,
    this.thechild,
  });

  final thewidth;
  final thechild;
  final thehight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: thehight,
          width: thewidth,
          color: Colors.transparent,
          child: Stack(
            children: [
              //Blurr effect
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ),
                child: Container(),
              ),

              //gradient effect

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.13),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          // previous value 0.15 and 0.05
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.1)
                        ]),
                        
                        ),
              ),
              //child
              Center(
                child: thechild,
              )
            ],
          ),
        ));
  }
}