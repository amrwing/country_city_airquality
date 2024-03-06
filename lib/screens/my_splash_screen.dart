import 'dart:async';

import 'package:contamination_cities/routes/routes.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  void startTimer() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      router.go('/home_screen');
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            "assets/imagenes/contaminacion.png",
            height: 100,
            width: 100,
          )),
          const Center(
            child: Text(
              "Cities Contamination APP",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
