/*SplachScreen Page*/
import 'package:flutter/material.dart';

class Splashpage extends StatelessWidget {
  const Splashpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        heightFactor: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
              child: const Text(
                "DETECTOR DE MASCARILLAS",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset("assets/splash.png", scale: 3),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: const CircularProgressIndicator(color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 10));
  }
}
