import 'package:clearanceapp/models/utils/Common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_advanced/sms_advanced.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';

import '../models/utils/Colors.dart';

import '../providers/officer.dart';
import '../providers/users.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApprovalScreen extends StatefulWidget {
  static const routeName = '/apprval-screen';

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    SmsSender sender = new SmsSender();

    final studentId = ModalRoute.of(context)!.settings.arguments as String;
    final clearanId = studentId;
    final loadedClearance =
        Provider.of<Users>(context, listen: false).findById(studentId);
    //final loadedrequest = Provider.of<User>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedClearance.id.toString()),
        ),
        body: SingleChildScrollView(
          child: Container(
              // decoration: BoxDecoration(
              //     color: color7,
              //     borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: EdgeInsets.all(10),
              //padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                'Name:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                loadedClearance.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                loadedClearance.phoneNumber.toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                loadedClearance.email,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                loadedClearance.department,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                loadedClearance.studentType,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: displaySize.width * .5,
                                    child: Text(loadedClearance.bursaryUrl)),
                                TextButton(
                                  onPressed: () async {
                                    var url = loadedClearance.bursaryUrl;
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
                                                  style:
                                                      TextStyle(color: color12),
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
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: GridView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 2.5,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 15,
                            ),
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Department',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Level',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value:
                                              loadedClearance.isDepartmentCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Faculty',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Level',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value: loadedClearance.isFacultyCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Student',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Affairs',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value: loadedClearance
                                              .isStudentAffairsCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Library',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value: loadedClearance.isLibraryCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Health',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Center',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value: loadedClearance
                                              .isTechnologistCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Alumni',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Office',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value: loadedClearance.isAlumniCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Bursary',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Office',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value: loadedClearance.isBursaryCheck,
                                          onChanged: (value) async {})),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GridTile(
                                  header: Center(
                                      child: Text(
                                    'Chief-Auditor ',
                                    style: TextStyle(fontSize: 22),
                                  )),
                                  child: Center(
                                    child: Text(
                                      'Officer',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  footer: GridTileBar(
                                      backgroundColor: color3,
                                      leading: Checkbox(
                                          activeColor: color13,
                                          checkColor: color3,
                                          value:
                                              loadedClearance.ischiefAuditCheck,
                                          onChanged: (value) async {
                                            setState(() {
                                              final oldStatus = loadedClearance
                                                  .ischiefAuditCheck;
                                              loadedClearance
                                                  .ischiefAuditCheck = value!;
                                            });
                                            final url =
                                                'https://clearance-db-default-rtdb.firebaseio.com/students/${loadedClearance.id}.json';
                                            await http.patch(Uri.parse(url),
                                                body: json.encode({
                                                  'id': loadedClearance.id
                                                      .toString(),
                                                  'name': loadedClearance.name,
                                                  'email':
                                                      loadedClearance.email,
                                                  'department': loadedClearance
                                                      .department,
                                                  'phoneNumber': loadedClearance
                                                      .phoneNumber,
                                                  'deptUrl':
                                                      loadedClearance.deptUrl,
                                                  'bursaryUrl': loadedClearance
                                                      .bursaryUrl,
                                                  'healthUrl':
                                                      loadedClearance.healthUrl,
                                                  'libraryUrl': loadedClearance
                                                      .libraryUrl,
                                                  'studentType': loadedClearance
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
                                            SmsMessage message = new SmsMessage(
                                                loadedClearance.phoneNumber,
                                                'Hello ${loadedClearance.name}, your clearance has been approved.\nKindly login to your portal and Generate your Report.');
                                            message.onStateChanged
                                                .listen((state) {
                                              if (state ==
                                                  SmsMessageState.Sent) {
                                                print('Sms Sent');
                                              } else if (state ==
                                                  SmsMessageState.Delivered) {
                                                print('Sms Delivered');
                                              }
                                            });
                                            sender.sendSms(message);
                                          })),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )
                ],
              )),
        ));
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
