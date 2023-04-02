import 'package:clearanceapp/models/utils/http_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Admin/admin_dashboard.dart';
import '../../models/Validation/FormValidation.dart';
import '../../models/utils/Colors.dart';
import '../../models/utils/Common.dart';
import '../../models/utils/Routes.dart';
import '../../providers/officer.dart';

import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';

class AdminRegister extends StatefulWidget {
  const AdminRegister({super.key});

  @override
  State<AdminRegister> createState() => AdminRegisterState();
}

class AdminRegisterState extends State<AdminRegister> {
  // Initial Selected Value
  String? dropdownvalue;

  // List of items in our dropdown menu
  var items = <String>[
    'Faculty',
    'Department',
    'Health-Center',
    'Student Affairs',
    'Bursary Office',
    'Library Office',
    'Chief-Auditor Office',
    'Alumni Office',
  ];
 

  createUser(OfficerModel officer) {
    storeNewUser(officer, context) async {
      await _db.collection('officers').add(officer.toJson()).then((e) {
        print("successful");
        Routes(context: context).navigateReplace(AdminDashoard());
      }).catchError((error, stackTrace) {
        _showErrorDialog("Somethig went wrong, Try again.");
        print(error.toString());
      });
    }
  }

  bool termsAndConditionCheck = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm_password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final RegisterController _registerController = RegisterController();
  final _db = FirebaseFirestore.instance;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm_password.dispose();
    super.dispose();
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

  var _isLoading = false;
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (passwordConfirmed()) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.text.trim(), password: _password.text.trim())
            .then((value) {
          postOfficerDetailsToFireStore();
          // createUser(officer).storeNewUser(signedInOfficer.user, context);

          //  OfficerManagement().storeNewUser(signedInOfficer.user, context);
        }).catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
          print(e);
        });

        //  addUserDetails(_name.text.trim(), dropdownvalue!, _email.text.trim());
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

    setState(() {
      _isLoading = false;
    });
  }

  postOfficerDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    OfficerModel officerModel = OfficerModel();
    officerModel.email = user!.email.toString();
    officerModel.uId = user.uid;
    officerModel.fullName = _name.text.trim();
    officerModel.password = _password.text.trim();
    officerModel.officerType = dropdownvalue!;

    await FirebaseFirestore.instance
        .collection('officers')
        .doc(user.uid)
        .set(officerModel.toMap());
    Fluttertoast.showToast(msg: 'Account Created Sucesfully :)');
    Routes(context: context).navigateReplace(AdminDashoard());
  }

  // Future addUserDetails(String name, String officerType, String email) async {
  //   await FirebaseFirestore.instance
  //       .collection('officers')
  //       .add({'name': name, 'officer type': officerType, 'email': email});
  // }

  bool passwordConfirmed() {
    if (_password.text.trim() == _confirm_password.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CustomCustomBackButton(onclickFunction: () {
                            Routes(context: context).back();
                          })),
                      const Center(
                        child: Text(
                          'Registration for Clearance Officers',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _name,
                                      backgroundColor: color7,
                                      iconColor: color3,
                                      isIconAvailable: true,
                                      onSaved: (value) {},
                                      hint: 'Full Name',
                                      icon: Icons.person,
                                      textInputType: TextInputType.text,
                                      validation: (value) =>
                                          FormValidation.notEmptyValidation(
                                              value, "Please enter name"),
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: color7,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                child: Icon(Icons
                                                    .supervised_user_circle_rounded),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Officer Type',
                                                style: TextStyle(
                                                    color: color8,
                                                    fontFamily:
                                                        'Raleway-SemiBold',
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownButton(
                                            value: dropdownvalue,
                                            icon: Icon(Icons.arrow_drop_down),
                                            items: items.map((item) {
                                              return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item));
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                dropdownvalue = newValue;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      onSaved: (value) {},
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _email,
                                      backgroundColor: color7,
                                      iconColor: color3,
                                      isIconAvailable: true,
                                      hint: 'Email Address',
                                      icon: Icons.email_outlined,
                                      textInputType: TextInputType.emailAddress,
                                      validation: (value) =>
                                          FormValidation.staffValidation(value,
                                              "Unauthorized Email Address"),
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      onSaved: (value) {},
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _password,
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
                                          .retypePasswordValidation(
                                              value, _password.text),
                                      obscureText: true),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Checkbox(
                                          checkColor: color3,
                                          fillColor:
                                              MaterialStateProperty.all(color7),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          value: termsAndConditionCheck,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              termsAndConditionCheck = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: SizedBox(
                                          width: displaySize.width * 0.65,
                                          child: Text(
                                            'By signing up I have agreed to the Terms & Conditions and Privacy Policy',
                                            style: TextStyle(
                                                color: color8,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                        if (termsAndConditionCheck == true) {
                                          _signUp();
                                        }
                                      }),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }

  getShadow() {
    return <BoxShadow>[
      const BoxShadow(
        color: Colors.black12,
        spreadRadius: -2,
        blurRadius: 5,
        offset: Offset(0, 4), // changes position of shadow
      ),
    ];
  }
}
