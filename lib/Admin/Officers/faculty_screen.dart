import 'package:clearanceapp/models/utils/Common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_advanced/sms_advanced.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/utils/Colors.dart';
import '../../providers/users.dart';

class FacultyScreen extends StatefulWidget {
  const FacultyScreen({super.key});
  static const routeName = '/fac=apvrl';

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  SmsSender sender = new SmsSender();

  @override
  Widget build(BuildContext context) {
    final studentId = ModalRoute.of(context)!.settings.arguments as String;
    final clearanId = studentId;
    final loadedClearance =
        Provider.of<Users>(context, listen: false).findById(studentId);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedClearance.id.toString()),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Name:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  loadedClearance.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: .5,
                            color: color8,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Phone Number:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  loadedClearance.phoneNumber.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: .5,
                            color: color8,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Email Address:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  loadedClearance.email,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: .5,
                            color: color8,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Department:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  loadedClearance.department,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: color8,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Student Type:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  loadedClearance.studentType,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: color8,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: 30,
                              width: displaySize.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: displaySize.width * .5,
                                      child: Text(loadedClearance.deptUrl)),
                                  TextButton(
                                    onPressed: () async {
                                      var url = loadedClearance.deptUrl;
                                      final uri = Uri.parse(url);
                                      if (!await launchUrl(
                                        uri,
                                      )) {
                                        return showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  content: Text(
                                                      'Could not lauch the link to document'),
                                                  title: Text(
                                                    'Error',
                                                    style: TextStyle(
                                                        color: color12),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        color: color12,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text('Okay'),
                                                      ),
                                                    )
                                                  ],
                                                ));
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: color3,
                                      side: BorderSide(width: 1),
                                    ),
                                    child: Text(
                                      'View Document',
                                      style: TextStyle(
                                          color: color7,
                                          fontFamily: 'Raleway-SemiBold'),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Container(
                        //padding: EdgeInsets.all(10),
                        // margin: EdgeInsets.only(left: 10, right: 10),
                        height: MediaQuery.of(context).size.height * .3,
                        decoration: BoxDecoration(
                            color: color9,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Center(
                                child: Text(
                                  "Faculty",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              Spacer(),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(color: color3),
                                      child: Center(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          color: color7,
                                          child: Checkbox(
                                              activeColor: color13,
                                              // checkColor: color9,
                                              value:
                                                  loadedClearance.isFacultyCheck,
                                              onChanged: (value) async {
                                                setState(() {
                                                  final oldStatus =
                                                      loadedClearance
                                                          .isFacultyCheck;
                                                  loadedClearance
                                                      .isFacultyCheck = value!;
                                                });
                                                final url =
                                                    'https://clearance-db-default-rtdb.firebaseio.com/students/${loadedClearance.id}.json';
                                                await http.patch(Uri.parse(url),
                                                    body: json.encode({
                                                      'id': loadedClearance.id
                                                          .toString(),
                                                      'name':
                                                          loadedClearance.name,
                                                      'email':
                                                          loadedClearance.email,
                                                      'department':
                                                          loadedClearance
                                                              .department,
                                                      'phoneNumber':
                                                          loadedClearance
                                                              .phoneNumber,
                                                      'deptUrl': loadedClearance
                                                          .deptUrl,
                                                      'bursaryUrl':
                                                          loadedClearance
                                                              .bursaryUrl,
                                                      'healthUrl':
                                                          loadedClearance
                                                              .healthUrl,
                                                      'libraryUrl':
                                                          loadedClearance
                                                              .libraryUrl,
                                                      'studentType':
                                                          loadedClearance
                                                              .studentType,
                                                      'isDepartmentCheck':
                                                          loadedClearance
                                                              .isDepartmentCheck,
                                                      'isAlumniCheck':
                                                          loadedClearance
                                                              .isAlumniCheck,
                                                      'isBursaryCheck':
                                                          loadedClearance
                                                              .isBursaryCheck,
                                                      'isLibraryCheck':
                                                          loadedClearance
                                                              .isLibraryCheck,
                                                      'isTechnologistCheck':
                                                          loadedClearance
                                                              .isTechnologistCheck,
                                                      'ischiefAuditCheck':
                                                          loadedClearance
                                                              .ischiefAuditCheck,
                                                      'isFacultyCheck':
                                                          loadedClearance
                                                              .isFacultyCheck,
                                                      'isStudentAffairsCheck':
                                                          loadedClearance
                                                              .isStudentAffairsCheck,
                                                    }));
                                              }),
                                        ),
                                      )))
                            ])),
                  )
                ]))));
  }

  bool value = false;
  _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text('Could not lauch the link to document'),
                title: Text(
                  'Error',
                  style: TextStyle(color: color12),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: color12,
                      padding: EdgeInsets.all(10),
                      child: Text('Okay'),
                    ),
                  )
                ],
              ));
      throw 'Could not lauch the link to document';
    }
  }
}
