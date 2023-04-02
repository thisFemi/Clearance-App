import 'package:clearanceapp/Student/student_dashboard.dart';
import 'package:clearanceapp/Student/student_login.dart';
import 'package:clearanceapp/models/Validation/FormValidation.dart';
import 'package:clearanceapp/models/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/utils/Colors.dart';
import '../providers/user.dart';
import '../providers/users.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class StudentUpload extends StatefulWidget {
  static const routeName = '/std-upoad';

  @override
  State<StudentUpload> createState() => _StudentUploadState();
}

class _StudentUploadState extends State<StudentUpload> {
  final _formKey = GlobalKey<FormState>();
  
 
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _busaryController = TextEditingController();
  final TextEditingController _libraryController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  var _expanded = false;
  var _expandedStep2 = false;
  var _expandedStep3 = false;

  String _selectedDepartment = '';
  String _selectedStdType = '';
  final List<String> _departments = [
    'Agriculture',
    "Accounting",
    'Economics',
    "Computer Science",
    "Law",
    "Biology",
    "English Education"
  ];
  final List<String> _studentTypes = [
    'Direct-Entry',
    'Diploma',
    'Part-Time',
    'UTME',
    'Masters',
    'Doctorate'
  ];

  var _addStudent = User(
      id: null,
      name: '',
      deptUrl: '',
      bursaryUrl: '',
      healthUrl: '',
      libraryUrl: '',
      department: '',
      studentType: '',
      email: '',
      phoneNumber: '');

  var _initValues = {
    'studentType': '',
    'name': '',
    'docUrl': '',
    'department': '',
    'email': '',
    'phoneNumber': ''
  };
  var _IsInit = true;
  var _IsLoading = false;
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

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    // _formKey2.currentState!.save();
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _busaryController.text.isEmpty ||
        _deptController.text.isEmpty ||
        _healthController.text.isEmpty ||
        _libraryController.text.isEmpty) {
      _showErrorDialog('Empty Fields');
    } else {
      if (_addStudent.id != null) {
        try {
          await Provider.of<Users>(context, listen: false)
              .addStudent(_addStudent);
          // Navigator.of(context).pushReplacementNamed(StudentDashboard.routeName,
          //     arguments: _addStudent.id.toString());
        } catch (error) {
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('An Error Occured'),
                    content: Text('Something Went Wrong'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Okay'))
                    ],
                  ));
        }
      } else {
        try {
          Center(child: CircularProgressIndicator());
          await Provider.of<Users>(context, listen: false)
              .addStudent(_addStudent);
          print('added');
        } catch (error) {
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('An Error Occured'),
                    content: Text('Something Went Wrong'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Okay'))
                    ],
                  ));
        }
      }
      Navigator.of(context).pushReplacementNamed(StudentDashboard.routeName,
          arguments: _addStudent.id.toString());
    }
  }

  var _isLoading = false;

  @override
  void dispose() {
    // _departmentFocusNode.dispose();
    // _nameFocusNode.dispose();
    // _docUrlController.dispose();
    // _studentTypeFocusode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    StudentCheck.routeName, (route) => false),
                icon: Icon(Icons.arrow_back)),
            automaticallyImplyLeading: false,
            title: Text(
              'Registration: $studentId',
            )),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Step 1',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Personal Informations'),
                        trailing: IconButton(
                          icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more,
                          ),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                      ),
                      if (_expanded)
                        SingleChildScrollView(
                          child: Container(
                            height: displaySize.height - 500,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ListView(shrinkWrap: true, children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _nameController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Full Name',
                                    icon: Icons.person,
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: value!,
                                          email: _addStudent.email,
                                          phoneNumber: _addStudent.phoneNumber,
                                          deptUrl: _addStudent.deptUrl,
                                          bursaryUrl: _addStudent.bursaryUrl,
                                          healthUrl: _addStudent.healthUrl,
                                          libraryUrl: _addStudent.libraryUrl,
                                          department: _selectedDepartment);
                                    },
                                    validation: (value) =>
                                        FormValidation.notEmptyValidation(
                                            value, 'Name Cannot be empty'),
                                    obscureText: false,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _emailController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Email Address',
                                    icon: Icons.mail,
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: _addStudent.name,
                                          email: value!,
                                          phoneNumber: _addStudent.phoneNumber,
                                          deptUrl: _addStudent.deptUrl,
                                          bursaryUrl: _addStudent.bursaryUrl,
                                          healthUrl: _addStudent.healthUrl,
                                          libraryUrl: _addStudent.libraryUrl,
                                          department: _selectedStdType);
                                    },
                                    validation: (value) =>
                                        FormValidation.emailValidation(
                                            value, 'Invalid Email'),
                                    obscureText: false,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _phoneController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Phone Number',
                                    icon: Icons.phone_android,
                                    textInputType: TextInputType.number,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: _addStudent.name,
                                          email: _addStudent.email,
                                          phoneNumber: value!.toString(),
                                          deptUrl: _addStudent.deptUrl,
                                          bursaryUrl: _addStudent.bursaryUrl,
                                          healthUrl: _addStudent.healthUrl,
                                          libraryUrl: _addStudent.libraryUrl,
                                          department: _selectedDepartment);
                                    },
                                    validation: (value) =>
                                        FormValidation.notEmptyValidation(value,
                                            'Phone Number Cannot be empty'),
                                    obscureText: false,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Step 2',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Student  Type'),
                        trailing: IconButton(
                          icon: Icon(
                            _expandedStep2
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                          onPressed: () {
                            setState(() {
                              _expandedStep2 = !_expandedStep2;
                            });
                          },
                        ),
                      ),
                      if (_expandedStep2)
                        SingleChildScrollView(
                          child: Container(
                            height: displaySize.height - 650,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: color3),
                                          child: TextButton(
                                              onPressed: () {
                                                showDepartmentModal(
                                                    context, _departments);
                                              },
                                              child: Text(
                                                'Select Department',
                                                style: TextStyle(
                                                    color: color7,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ),
                                        Container(
                                            width: displaySize.width * .4,
                                            height: 50,
                                            child: Card(
                                                elevation: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    '$_selectedDepartment',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: color3),
                                            child: TextButton(
                                                onPressed: () {
                                                  showStudentTypeModal(
                                                      context, _studentTypes);
                                                },
                                                child: Text(
                                                  'Select Student Type',
                                                  style: TextStyle(
                                                      color: color7,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                          ),
                                          Container(
                                            width: displaySize.width * .4,
                                            height: 50,
                                            child: Card(
                                                elevation: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    '$_selectedStdType',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Step 3',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Upload Link to Documents'),
                        trailing: IconButton(
                          icon: Icon(
                            _expandedStep3
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                          onPressed: () {
                            setState(() {
                              _expandedStep3 = !_expandedStep3;
                            });
                          },
                        ),
                      ),
                      if (_expandedStep3)
                        SingleChildScrollView(
                          child: Container(
                            height: displaySize.height - 450,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Text(
                                      'All Required Documents are to be scanned and uploaded to Google drive seperately.'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _deptController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Document Required for Department',
                                    icon: Icons.link,
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: _addStudent.name,
                                          email: _addStudent.email,
                                          phoneNumber: _addStudent.phoneNumber,
                                          deptUrl: value!,
                                          bursaryUrl: _addStudent.bursaryUrl,
                                          healthUrl: _addStudent.healthUrl,
                                          libraryUrl: _addStudent.libraryUrl,
                                          department: _selectedDepartment);
                                    },
                                    validation: (value) =>
                                        FormValidation.urlValidation(
                                            value, 'Please enter a valid URL'),
                                    obscureText: false,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _busaryController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Document Required for Bursary Unit',
                                    icon: Icons.link,
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: _addStudent.name,
                                          email: _addStudent.email,
                                          phoneNumber: _addStudent.phoneNumber,
                                          deptUrl: _addStudent.deptUrl,
                                          bursaryUrl: value!,
                                          healthUrl: _addStudent.healthUrl,
                                          libraryUrl: _addStudent.libraryUrl,
                                          department: _selectedDepartment);
                                    },
                                    validation: (value) =>
                                        FormValidation.urlValidation(
                                            value, 'Please enter a valid URL'),
                                    obscureText: false,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _libraryController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Document Required for Library',
                                    icon: Icons.link,
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: _addStudent.name,
                                          email: _addStudent.email,
                                          phoneNumber: _addStudent.phoneNumber,
                                          deptUrl: _addStudent.deptUrl,
                                          bursaryUrl: _addStudent.bursaryUrl,
                                          healthUrl: _addStudent.healthUrl,
                                          libraryUrl: value!,
                                          department: _selectedDepartment);
                                    },
                                    validation: (value) =>
                                        FormValidation.urlValidation(
                                            value, 'Please enter a valid URL'),
                                    obscureText: false,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _healthController,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Document Required for Health Center',
                                    icon: Icons.link,
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {
                                      _addStudent = User(
                                          id: studentId,
                                          studentType: _selectedStdType,
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          phoneNumber: _phoneController.text
                                              .trim()
                                              .toString(),
                                          deptUrl: _deptController.text.trim(),
                                          bursaryUrl:
                                              _busaryController.text.trim(),
                                          healthUrl:
                                              _healthController.text.trim(),
                                          libraryUrl:
                                              _libraryController.text.trim(),
                                          department: _selectedDepartment);
                                    },
                                    validation: (value) =>
                                        FormValidation.urlValidation(
                                            value, 'Please enter a valid URL'),
                                    obscureText: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                            value: termsAndConditionCheck,
                            // checkColor: color2,
                            activeColor: color3,
                            checkColor: color7,
                            //fillColor: MaterialStateProperty.all(color8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            onChanged: (value) {
                              setState(() {
                                termsAndConditionCheck = value!;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          width: displaySize.width * 0.65,
                          child: Text(
                            'I Acknowledge that the inputted details are valid',
                            style: TextStyle(
                                fontSize: 18,
                                color: color4,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                    child: CustomButton(
                        buttonText: 'Login',
                        textColor: color6,
                        backgroundColor: color3,
                        isBorder: false,
                        borderColor: color6,
                        onclickFunction: () {
                          FocusScope.of(context).unfocus();

                          if (termsAndConditionCheck == true) {
                            _saveForm();
                          } else {
                            _showErrorDialog(
                                'Acknowledge the Terms and Condition');
                          }
                        }))
              ],
            ),
          ),
        ));
  }

  bool termsAndConditionCheck = false;
  void showDepartmentModal(
    context,
    List listName,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            height: displaySize.height * .4,
            alignment: Alignment.center,
            child: ListView.separated(
              itemBuilder: ((context, index) {
                return ListTile(
                    tileColor: color8,
                    leading: Text(listName[index]),
                    onTap: () {
                      setState(() {
                        _selectedDepartment = listName[index];
                      });
                      Navigator.of(context).pop();
                    });
              }),
              separatorBuilder: (context, int) {
                return Divider();
              },
              itemCount: listName.length,
            ),
          );
        });
  }

  void showStudentTypeModal(
    context,
    List listName,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            height: displaySize.height * .4,
            alignment: Alignment.center,
            child: ListView.separated(
              itemBuilder: ((context, index) {
                return ListTile(
                  tileColor: color8,
                  leading: Text(listName[index]),
                  onTap: () {
                    setState(() {
                      _selectedStdType = listName[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
              separatorBuilder: (context, int) {
                return Divider();
              },
              itemCount: listName.length,
            ),
          );
        });
  }
}
