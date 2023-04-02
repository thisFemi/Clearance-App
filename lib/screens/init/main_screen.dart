import 'package:clearanceapp/Student/student_main.dart';
import 'package:clearanceapp/screens/Auth/login.dart';
import 'package:clearanceapp/screens/Auth/register.dart';
import 'package:flutter/material.dart';

import '../../Models/Utils/Images.dart';
import '../../Models/Utils/Routes.dart';
import '../../Student/student_login.dart';
import '../../models/utils/Colors.dart';
import '../../models/utils/Common.dart';
import '../../widgets/custom_button.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: color3,
        body: SizedBox(
            height: displaySize.height,
            width: displaySize.width,
            child: Stack(
              // height: displaySize.height * 0.5,
              alignment: Alignment.center,
              children: [
                Positioned(
                    child: SizedBox(
                  width: displaySize.width,
                  height: displaySize.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color3,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.dstATop),
                        image: AssetImage(mainScreenBg),
                      ),
                    ),
                    child: const Text(
                      '',
                    ),
                  ),
                )),
                Positioned(
                    child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            'Hello',
                            style: TextStyle(color: color9, fontSize: 50.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            'Welcome to AAUA E-Clearance App',
                            style: TextStyle(color: color9, fontSize: 18.0),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                Positioned(
                    bottom: displaySize.height * 0.02,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 5.0),
                          child: CustomButton(
                              buttonText: 'Student Login',
                              textColor: color6,
                              backgroundColor: color3,
                              isBorder: false,
                              borderColor: color6,
                              onclickFunction: () {
                                Routes(context: context)
                                    .navigate(StudentAuthScreen());
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 5.0),
                          child: CustomButton(
                              buttonText: 'Staff Login',
                              textColor: color3,
                              backgroundColor: color6,
                              isBorder: true,
                              borderColor: color3,
                              onclickFunction: () {
                                Routes(context: context)
                                    .navigate(const Login());
                              }),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
