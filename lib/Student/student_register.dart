import 'dart:io';

import 'package:clearanceapp/Student/student_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/Utils/Routes.dart';
import '../models/Validation/FormValidation.dart';
import '../models/utils/Colors.dart';
import '../models/utils/Common.dart';
import '../providers/student.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class StudentRegister extends StatefulWidget {
  static const routeName = '/std-reg';
  const StudentRegister({super.key});

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final _db = FirebaseFirestore.instance;
  final TextEditingController _matricController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirm_password = TextEditingController();

  var domain = '@aaua.edu.ng';
  final _formKey = GlobalKey<FormState>();
  postStudentDetails(String matric) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String errorMessage = '';
    StudentModel studentModel = StudentModel();
    studentModel.matric = _matricController.text.trim();
    studentModel.uId = user!.uid;
    studentModel.password = _passwordController.text.trim();
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .set(studentModel.toMap())
          .then((e) {
        Fluttertoast.showToast(msg: 'Account Created Sucesfully :)');
        Navigator.pushReplacementNamed(context, StudentUpload.routeName,
            arguments: matric);
      }).catchError((e) {
        _showErrorDialog('e.code.toString()');
      });
    } on HttpException catch (error) {
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
    } catch (error) {
      const errorMessage =
          'Could not authenticate user, please try again later';
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured'),
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

  Future<void> _signUp(String matric) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (passwordConfirmed()) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: matric + domain,
                password: _passwordController.text.trim())
            .then((value) {
          postStudentDetails(matric);
        }).catchError((e) {
          _showErrorDialog(e.toString());
          //Fluttertoast.showToast(msg: e!.message);
          print(e);
        });
      } else {
        _showErrorDialog("Password Mis-Match");
      }
    } on HttpException catch (error) {
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
    } catch (error) {
      print(error);
      const errorMessage =
          'Could not authenticate user, please try again later';
      _showErrorDialog(errorMessage);
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() == _confirm_password.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentId = ModalRoute.of(context)!.settings.arguments as String;
    _matricController.text = studentId;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color6,
      body: SafeArea(
          child: SizedBox(
              height: displaySize.height,
              width: displaySize.width,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child:
                                  CustomCustomBackButton(onclickFunction: () {
                                Routes(context: context).back();
                              })),
                          const Center(
                            child: Text(
                              'Account Registration ',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: CustomTextFormField(
                                          readOnly: true,
                                          height: 5.0,
                                          controller: _matricController,
                                          backgroundColor: color7,
                                          iconColor: color3,
                                          isIconAvailable: true,
                                          onSaved: (value) {},
                                          hint: 'Matric Number',
                                          icon: Icons.school,
                                          textInputType: TextInputType.text,
                                          validation: (value) =>
                                              FormValidation.notEmptyValidation(
                                                  value, "Error"),
                                          obscureText: false),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      child: CustomTextFormField(
                                          onSaved: (value) {},
                                          readOnly: false,
                                          height: 5.0,
                                          controller: _passwordController,
                                          backgroundColor: color7,
                                          iconColor: color3,
                                          isIconAvailable: true,
                                          hint: 'Password',
                                          icon: Icons.lock_open,
                                          textInputType: TextInputType.text,
                                          validation: (value) =>
                                              FormValidation.passwordValidation(
                                                  value),
                                          obscureText: true),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      child: CustomTextFormField(
                                          onSaved: (value) {},
                                          readOnly: false,
                                          height: 5.0,
                                          controller: _confirm_password,
                                          backgroundColor: color7,
                                          iconColor: color3,
                                          isIconAvailable: true,
                                          hint: 'Confirm Password',
                                          icon: Icons.lock_open,
                                          textInputType: TextInputType.text,
                                          validation: (value) => FormValidation
                                              .retypePasswordValidation(value,
                                                  _confirm_password.text),
                                          obscureText: true),
                                    ),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 20.0),
                            child: CustomButton(
                                buttonText: 'SignUp',
                                textColor: color6,
                                backgroundColor: color3,
                                isBorder: false,
                                borderColor: color6,
                                onclickFunction: () {
                                  FocusScope.of(context).unfocus();

                                  _signUp(studentId);
                                }),
                          ),
                        ],
                      ))))),
    );
  }
}
