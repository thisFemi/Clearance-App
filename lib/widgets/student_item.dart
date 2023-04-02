import 'package:clearanceapp/providers/user.dart' as students;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Admin/Officers/alumni.dart';
import '../Admin/Officers/busrary.dart';
import '../Admin/Officers/department_screen.dart';
import '../Admin/Officers/faculty_screen.dart';
import '../Admin/Officers/healthCenter.dart';
import '../Admin/Officers/library.dart';
import '../Admin/Officers/studentAffairs.dart';
import '../Admin/approval_screen.dart';
import '../Models/Utils/Routes.dart';
import '../models/utils/Colors.dart';
import '../providers/officer.dart';

class StudentItem extends StatefulWidget {
  const StudentItem({super.key});

  @override
  State<StudentItem> createState() => _StudentItemState();
}

class _StudentItemState extends State<StudentItem> {
  User? user = FirebaseAuth.instance.currentUser;
  OfficerModel loggedInUser = OfficerModel();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('officers')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = OfficerModel.fromMap(value.data());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<students.User>(context, listen: false);

    return Container(
        child: Card(
      child: ListTile(
          title: Text(
            student.id.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            student.department,
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            if (loggedInUser.officerType == 'Faculty') {
              Navigator.of(context).pushNamed(
                FacultyScreen.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Department') {
              Navigator.of(context).pushNamed(
                DepartmentalScreen.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Student Affairs') {
              Navigator.of(context).pushNamed(
                StudentAffairsOffice.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Health-Center') {
              Navigator.of(context).pushNamed(
                HealthOffice.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Bursary Office') {
              Navigator.of(context).pushNamed(
                BursaryOffice.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Library Office') {
              Navigator.of(context).pushNamed(
                LibraryOffice.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Chief-Auditor Office') {
              Navigator.of(context).pushNamed(
                ApprovalScreen.routeName,
                arguments: student.id,
              );
            } else if (loggedInUser.officerType == 'Alumni Office') {
              Navigator.of(context).pushNamed(
                AlumniOffice.routeName,
                arguments: student.id,
              );
            } else {
            //  Navigator.of(context).pushNamed(ErrorScreen.routeName);
            }
          },
          trailing: Icon(
            student.ischiefAuditCheck ? Icons.check_circle : Icons.pending,
            color: student.ischiefAuditCheck ? color13 : color4,
          )),
    ));
  }
}
