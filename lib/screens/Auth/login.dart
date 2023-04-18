import 'dart:io';

import 'package:clearanceapp/screens/Auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Admin/admin_dashboard.dart';
import '../../models/Validation/FormValidation.dart';
import '../../models/utils/Colors.dart';
import '../../models/utils/Common.dart';
import '../../models/utils/Images.dart';
import '../../models/utils/Routes.dart';
import '../../providers/auth.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final LoginController _loginController = LoginController();
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Map<String, String> _authData = {'email': '', 'password': ''};
  @override
  var _isLoading = false;
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    _keyForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    var key = 'email';
    if (_authData[key] != null && _authData['password'] != null) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _authData['email']!,
            password: _authData['password']!,
          )
          .then((user) => Navigator.of(context)
              .pushReplacementNamed(AdminDashoard.routeName))
          .catchError((error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is to weak';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could  not find a user with that email';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid Password';
        }
        _showErrorDialog(errorMessage);
  
      }).onError((error, stackTrace) {
        const errorMessage =
            'Could not authenticate user, please try again later';
        _showErrorDialog(errorMessage);
      });
    } else {
      _showErrorDialog('Empty Details');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void initState() {
    // _username.text = 'staff / business@gmail.com';
    // _username.text = 'admin3@clearance.aaua.edu.ng';
    // _password.text = '123456';

    //authProcess();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: color6,
        body: SingleChildScrollView(
          child: SafeArea(
              child: SizedBox(
            height: displaySize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Form(
                  key: _keyForm,
                  child: Stack(
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
                                    Colors.black.withOpacity(.2),
                                    BlendMode.dstATop),
                                image: AssetImage(loginScreenBg),
                              )),
                          child: const Text(''),
                        ),
                      )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(
                              child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: displaySize.width * .4,
                                height: displaySize.width * .3,
                                //  color: color7,
                                child: Center(
                                  child: SizedBox(
                                    width: displaySize.width * .3,
                                    child: Image.asset(logo),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: color7,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0))),
                            child: Column(children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              const Center(
                                child: Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: CustomTextFormField(
                                  readOnly: false,
                                  height: 5.0,
                                  controller: _username,
                                  backgroundColor: color7,
                                  iconColor: color3,
                                  isIconAvailable: true,
                                  hint: 'Staff Id/Username',
                                  icon: Icons.email_outlined,
                                  textInputType: TextInputType.text,
                                  onSaved: (value) {
                                    _authData['email'] = value!;
                                  },
                                  validation: (value) =>
                                      FormValidation.staffValidation(value,
                                          'Invalid Email Address / Username'),
                                  obscureText: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: CustomTextFormField(
                                    height: 5.0,
                                    hint: 'Password',
                                    icon: Icons.lock_outlined,
                                    readOnly: false,
                                    textInputType: TextInputType.text,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    onSaved: (value) {
                                      _authData['password'] = value!;
                                    },
                                    validation: (value) =>
                                        FormValidation.passwordValidation(
                                            value),
                                    controller: _password,
                                    obscureText: true),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'Forgot Password?',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 45,
                                  vertical: 5,
                                ),
                                child: SizedBox(
                                  height: 50.0,
                                  width: displaySize.width * 0.85,
                                  child: TextButton(
                                    onPressed: _submit,
                                    style: TextButton.styleFrom(
                                      backgroundColor: color3,
                                    ),
                                    child: _isLoading
                                        ? SpinKitThreeBounce(
                                            color: color5, size: 40)
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                                color: color6,
                                                fontFamily: 'Raleway-SemiBold'),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 40.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () => Routes(context: context)
                                        .navigate(AdminRegister()),
                                    child: const Text(
                                      'No account yet, Register Now',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              )
                            ]),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          )),
        ));
  }
}
