import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/views/pages/home/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkAndNavigate();
  }

  checkAndNavigate() async {
    await Future.delayed(Duration(seconds: 2));

    Get.off(Home());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              SizedBox(height: 30),
              Container(
                child: Column(children: [
                  Text(
                    'Welcome',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  Text('To'),
                  Text(
                    'Todo App',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
