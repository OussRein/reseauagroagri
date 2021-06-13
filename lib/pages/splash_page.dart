import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Container(
                      height: 200,
                      
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
        ),
      ),
    );
  }
}
