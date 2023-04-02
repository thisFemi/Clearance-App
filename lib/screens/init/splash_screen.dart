import 'dart:async';

import 'package:clearanceapp/Admin/admin_dashboard.dart';
import 'package:clearanceapp/Admin/approval_screen.dart';
import 'package:clearanceapp/Student/student_login.dart';
import 'package:clearanceapp/Student/student_main.dart';
import 'package:clearanceapp/screens/Auth/login.dart';
import 'package:flutter/material.dart';

import '../../Models/Utils/Images.dart';
import '../../Models/Utils/Routes.dart';
import '../../models/utils/Colors.dart';
import '../../models/utils/Common.dart';
import 'main_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  bool isTimerInitialized = false;

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    if (isTimerInitialized) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color6,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: displaySize.width * 0.5,
                  child: Image.asset(logo),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SpinKitThreeBounce(color: color14, size: 40),
            ],
          ),
          Positioned(
              bottom: 0.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'AAUA e-Clerannce ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'v1.0',
                      style: const TextStyle(fontSize: 11.0),
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }

  void startApp() async {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      isTimerInitialized = true;
      _timer.cancel();
      Routes(context: context).navigateReplace(MainScreen());
    });
  }
}
