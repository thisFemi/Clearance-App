// import 'package:pdf/pdf.dart';

import 'dart:typed_data';
import 'package:clearanceapp/Student/pdfPreview.dart';
import 'package:clearanceapp/Student/pdfexpot.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:clearanceapp/screens/init/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../models/utils/Colors.dart';
import '../models/utils/Common.dart';

import '../providers/users.dart';
import '../widgets/custom_button.dart';

class StudentDashboard extends StatefulWidget {
  static const routeName = '/std-dashboard';

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final centerTextStyle = const TextStyle(
      fontSize: 64, color: Colors.lightBlue, fontWeight: FontWeight.bold);
  late ValueNotifier<double> valueNotifier;
  @override
  iniState() {
    super.initState();
    valueNotifier = ValueNotifier(75.0);
  }

  @override
  Widget build(BuildContext context) {
    final studentd = ModalRoute.of(context)!.settings.arguments as String;
    final loadedStudent =
        Provider.of<Users>(context, listen: false).findById(studentd);
    // if (loadedStudent.isDepartmentCheck == true) {
    //   valueNotifier = ValueNotifier(20.0);
    // } else if (loadedStudent.isFacultyCheck == true) {
    //   valueNotifier = ValueNotifier(40.0);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedStudent.name),
      ),
      drawer: Drawer(
        //height: displaySize.height,
        backgroundColor: color6,
        width: displaySize.width * .7,

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                color: color3,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      loadedStudent.id.toString(),
                      style: TextStyle(color: color7, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      loadedStudent.department,
                      style: TextStyle(color: color7, fontSize: 14),
                    )
                  ],
                ),
              ),
              Container(
                color: color6,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    buildListTile('Profile', Icons.account_circle, () => null),
                    buildListTile('Settings', Icons.settings, () => null),
                    buildListTile('Complants/Enquires',
                        Icons.info_outline_rounded, () => null),
                    buildListTile('SignOut', Icons.logout, () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MainScreen.routeName,
                          (Route<dynamic> route) => false);
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              //   decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.bottomRight,
              //     end: Alignment.bottomRight,
              //     colors: [

              //     Color(0xff0d324d), Color(0xff7f5a83)])
              // ),

              alignment: Alignment.center,
              child: SimpleCircularProgressBar(
                size: 130,
                valueNotifier: loadedStudent.ischiefAuditCheck
                    ? ValueNotifier(100.0)
                    : ValueNotifier(25),
                progressStrokeWidth: 24,
                backStrokeWidth: 24,
                mergeMode: true,
                onGetText: (value) {
                  return Text(
                    '${value.toInt()}',
                    style: centerTextStyle,
                  );
                },
                progressColors: const [Colors.cyan, Colors.purple],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * .5,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2.1,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 10,
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Department \nLevel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isDepartmentCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isDepartmentCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isDepartmentCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Faculty \nLevel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isFacultyCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isFacultyCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isFacultyCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Student \nAffairs ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isStudentAffairsCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isStudentAffairsCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isStudentAffairsCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Bursary ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isBursaryCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isBursaryCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isBursaryCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Alumni\nOffice',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isAlumniCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isAlumniCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isAlumniCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Library',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isLibraryCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isLibraryCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isLibraryCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Health\nCenter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.isTechnologistCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.isTechnologistCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.isTechnologistCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                  ClipRRect(
                      child: Container(
                    // width: 50,
                    // height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Chief\nAuditor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: loadedStudent.ischiefAuditCheck
                                      ? color10
                                      : color8),
                              child: Text(
                                loadedStudent.ischiefAuditCheck
                                    ? "Approved"
                                    : "Pending",
                                style: TextStyle(
                                    color: loadedStudent.ischiefAuditCheck
                                        ? color3
                                        : color3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: loadedStudent.ischiefAuditCheck
                    ? CustomButton(
                        buttonText: 'View Report',
                        textColor: color6,
                        backgroundColor: color3,
                        isBorder: false,
                        borderColor: color6,
                        onclickFunction: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PdfPreviewPage(
                                user: loadedStudent,
                              ),
                            ),
                          );
                        })
                    : Text(""))
          ],
        ),
      ),
    );
  }

  Widget buildListTile(String title, IconData icon, Function() tapHandler) {
    return ListTile(
      onTap: tapHandler,
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
