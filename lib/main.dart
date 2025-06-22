import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:device_preview/device_preview.dart';

import 'register_page.dart';


void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ammu App',
      debugShowCheckedModeBanner: false,
      routes: {'/next': (context) => SignUpScreen()},
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/next');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 37, 66),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.asset('images/ammu_girl.png', fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            const Text(
              'AMMU',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 5.0,
                fontFamily: 'Courier'
              ),
            ),
            SizedBox(height: 4),
            const Text(
              'Move With Mother Care',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 1.2
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
