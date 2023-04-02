import 'package:clearanceapp/Student/student_dashboard.dart';
import 'package:clearanceapp/Student/student_register.dart';
import 'package:clearanceapp/Student/student_upload.dart';
import 'package:clearanceapp/models/Validation/FormValidation.dart';
import 'package:clearanceapp/models/utils/Utils.dart';
import 'package:clearanceapp/screens/init/main_screen.dart';
import 'package:clearanceapp/widgets/custom_back_button.dart';
import 'package:clearanceapp/widgets/custom_button.dart';
import 'package:clearanceapp/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Models/Utils/Routes.dart';
import '../models/utils/Colors.dart';
import '../models/utils/Common.dart';
import '../providers/users.dart';

class StudentCheck extends StatefulWidget {
  static const routeName = '/std-login';
  const StudentCheck({super.key});

  @override
  State<StudentCheck> createState() => _StudentCheckState();
}

class _StudentCheckState extends State<StudentCheck> {
  final TextEditingController _matric = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  var _isInit = true;
  @override
  void initState() {
    if (_isInit) {
      Provider.of<Users>(context, listen: false).fetchAndSetClearanceOrders(context);
    }
    _isInit = false;
    super.initState();
  }

  var _isLoading = false;
  void _onSubmit() {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    _keyForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Fluttertoast.showToast(
        msg: "Matric Number${_matric.text.trim()} is Eligible");
    Navigator.of(context).pushNamed(
      StudentRegister.routeName,
      arguments: _matric.text,
    );
    print("Good");
  }

  @override
  void dispose() {
    _matric.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var studentId = '';
    final TextEditingController _textController = TextEditingController();
    var users = Provider.of<Users>(context, listen: false);
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color6,
      body: SafeArea(
        child: SizedBox(
          height: displaySize.height,
          width: displaySize.width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: CustomCustomBackButton(onclickFunction: () {
                    Routes(context: context).back();
                  }),
                ),
                SizedBox(
                  height: 100,
                ),
                const Center(
                  child: Text(
                    'Student Login',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Form(
                    key: _keyForm,
                    child: CustomTextFormField(
                      readOnly: false,
                      height: 5.0,
                      controller: _matric,
                      backgroundColor: color7,
                      iconColor: color3,
                      isIconAvailable: true,
                      hint: 'Matric Number',
                      icon: Icons.school,
                      textInputType: TextInputType.text,
                      onSaved: (value) {
                        //    _authData['matric'] = value!;
                      },
                      validation: (value) => FormValidation.studentValidation(
                          value, 'Student not eligible'),
                      obscureText: false,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100.0,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                    child: SizedBox(
                      height: 50.0,
                      width: displaySize.width * 0.85,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: color3,
                              side: BorderSide(color: color6, width: 1)),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: color6, fontFamily: 'Raleway-SemiBold'),
                          ),
                          onPressed: _onSubmit),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool termsAndConditionCheck = false;
}
