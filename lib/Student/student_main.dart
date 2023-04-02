import 'package:clearanceapp/Student/student_dashboard.dart';
import 'package:clearanceapp/Student/student_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Models/Utils/Routes.dart';
import '../models/Validation/FormValidation.dart';
import '../models/utils/Colors.dart';
import '../models/utils/Common.dart';
import '../models/utils/theme.dart';
import '../providers/users.dart';
import '../screens/Auth/register.dart';
import '../widgets/custom_text_form_field.dart';

class StudentAuthScreen extends StatefulWidget {
  const StudentAuthScreen({super.key});

  @override
  State<StudentAuthScreen> createState() => _StudentAuthScreenState();
}

class _StudentAuthScreenState extends State<StudentAuthScreen> {
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController _matric = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Map<String, String> _authData = {'matric': '', 'password': ''};
  @override
  void initState() {
    _matric.text = '17040418';
    _password.text = '123456';
    super.initState();
  }

  var _isLoading = false;
  var domain = '@aaua.edu.ng';
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

  Future<void> _login() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    _keyForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    var key = 'matric';
    if (_authData[key] != null && _authData['password'] != null) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _authData['matric']!,
        password: _authData['password']!,
      )
          .then((user) {
        print('logged in');
        Provider.of<Users>(context, listen: false)
            .fetchAndSetClearanceOrders(context)
            .then((value) {
          Navigator.of(context).pushReplacementNamed(StudentDashboard.routeName,
              arguments: _matric.text);
        }).catchError((e) {
          _showErrorDialog('User not Found');
        });
      }).catchError((error) {
        var errorMessage = 'Authentication failed';
        print(error);
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
        // _showErrorDialog(errorMessage);
      });
    } else {
      _showErrorDialog('Empty Details');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Color left = Colors.black;
  Color right = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      CustomTheme.loginGradientStart,
                      CustomTheme.loginGradientEnd
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 1.0),
                    stops: <double>[0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: Image(
                    height:
                        MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                    fit: BoxFit.fill,
                    image: const AssetImage('assets/images/login_logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    child: Form(
                        key: _keyForm,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: CustomTextFormField(
                                readOnly: false,
                                height: 5.0,
                                controller: _matric,
                                backgroundColor: color7,
                                iconColor: color3,
                                isIconAvailable: true,
                                hint: 'Matric Number',
                                icon: Icons.email_outlined,
                                textInputType: TextInputType.text,
                                onSaved: (value) {
                                  _authData['matric'] = value! + domain;
                                },
                                validation: (value) =>
                                    FormValidation.notEmptyValidation(
                                        value, 'Invalid Matric Number'),
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
                                      FormValidation.passwordValidation(value),
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
                                  style: TextStyle(fontWeight: FontWeight.w500),
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
                                  onPressed: _login,
                                  style: TextButton.styleFrom(
                                    backgroundColor: color3,
                                  ),
                                  child: _isLoading == true
                                      ? SizedBox(
                                          child: SpinKitThreeBounce(
                                            color: color7,
                                          ),
                                        )
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
                                  onTap: () => Navigator.pushNamed(
                                      context, StudentCheck.routeName),
                                  child: const Text(
                                    'No account yet, Register Now',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
