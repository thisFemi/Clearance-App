import 'dart:convert';

import 'package:clearanceapp/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/utils/Colors.dart';

class Users with ChangeNotifier {
  List<User> _users = [
    // User(
    //   id: '170404110',
    //   name: 'Oluafemi Jacob',
    //   studentType: 'UTME',
    //   department: 'Computer Science',
    //   libraryUrl: 'Urlrlrlrl',
    //   bursaryUrl: '',
    //   deptUrl: '',
    //   healthUrl: '',
    //   email: 'oluwafemijacob1@gmail.com',
    //   phoneNumber: '09094424301',
    //   isDepartmentCheck: true,
    // ),
    // User(
    //     id: '170402088',
    //     studentType: 'UTME',
    //     phoneNumber: '09094424301',
    //     email: 'duyi@email.com',
    //     name: 'Kolawole Duyi',
    //     department: 'Chemstry',
    //     isFinalCheck: false,
    //     docUrl: 'Urlrlrlrl'),
    // User(
    //     id: '170404105',
    //     studentType: 'UTME',
    //     email: '@timi.com',
    //     phoneNumber: '080080800',
    //     name: 'Kolawole Timilehin',
    //     department: 'Chemistry',
    //     docUrl: 'Urlrlrlrl')
  ];

  List<User> get users {
    return [..._users];
  }

  // List<User> get students {
  //   return _users.where((usertype) => usertype.isStudent).toList();
  // }

  List<User> get clearedStudents {
    return _users.where((student) => student.ischiefAuditCheck).toList();
  }

  User findById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  // User notFound(String id) {

  // //  return _users.firstWhere((user) => user.id != id)? true:false;
  // }

  Future<void> fetchAndSetClearanceOrders(BuildContext context) async {
    var url = 'https://clearance-db-default-rtdb.firebaseio.com/students.json';
    try {
      final response = await http.get(Uri.parse(url));
      final List<User> pendingRequests = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      url =
          'https://clearance-db-default-rtdb.firebaseio.com/students/cleared.json';
      final clearedResponse = await http.get(Uri.parse(url));
      final clearedData = json.decode(clearedResponse.body);
      data.forEach((requestId, requestData) {
        pendingRequests.add(User(
            //personal infos
            id: requestData['id'],
            email: requestData['email'],
            phoneNumber: requestData['phoneNumber'],
            studentType: requestData['studentType'],
            name: requestData['name'],
            //document for clearance
            deptUrl: requestData['deptUrl'],
            bursaryUrl: requestData['bursaryUrl'],
            healthUrl: requestData['healthUrl'],
            libraryUrl: requestData['libraryUrl'],
            department: requestData['department'],
            //officers
            isDepartmentCheck: requestData['isDepartmentCheck'],
            isAlumniCheck: requestData['isAlumniCheck'],
            isBursaryCheck: requestData['isBursaryCheck'],
            isLibraryCheck: requestData['isLibraryCheck'],
            isTechnologistCheck: requestData['isTechnologistCheck'],
            ischiefAuditCheck: requestData['ischiefAuditCheck'],
            isFacultyCheck: requestData['isFacultyCheck'],
            isStudentAffairsCheck: requestData['isStudentAffairsCheck']));
      });
      _users = pendingRequests;
      notifyListeners();
    } catch (error) {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text('Could not complete request'),
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
                      color: color3,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Okay',
                        style: TextStyle(color: color7),
                      ),
                    ),
                  )
                ],
              ));
    }
  }

  Future<void> addStudent(User student) async {
    final url =
        'https://clearance-db-default-rtdb.firebaseio.com/students.json';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'id': student.id,
            'name': student.name,
            'email': student.email,
            'department': student.department,
            'phoneNumber': student.phoneNumber,
            'studentType': student.studentType,
            //documents links
            'bursaryUrl': student.bursaryUrl,
            'deptUrl': student.deptUrl,
            'healthUrl': student.healthUrl,
            'libraryUrl': student.libraryUrl,

            //Officers
            'isDepartmentCheck': student.isDepartmentCheck,
            'isAlumniCheck': student.isAlumniCheck,
            'isBursaryCheck': student.isBursaryCheck,
            'isTechnologistCheck': student.isTechnologistCheck,
            'isLibraryCheck': student.isLibraryCheck,
            'isFacultyCheck': student.isFacultyCheck,
            'isStudentAffairsCheck': student.isStudentAffairsCheck,
            'ischiefAuditCheck': student.ischiefAuditCheck
          }));
      final newStudent = User(
          phoneNumber: student.phoneNumber,
          email: student.email,
          id: student.id,
          studentType: student.studentType,
          name: student.name,
          department: student.department,
          deptUrl: student.deptUrl,
          bursaryUrl: student.bursaryUrl,
          healthUrl: student.healthUrl,
          libraryUrl: student.libraryUrl);

      _users.add(newStudent);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateDetails(String? id, User newUser) async {
    final userInfo = _users.indexWhere((record) => record.id == id);
    if (userInfo >= 0) {
      final url =
          'https://clearance-db-default-rtdb.firebaseio.com/students/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newUser.name,
            'department': newUser.department,
            'studentType': newUser.studentType,
            'phoneNumber': newUser.phoneNumber,
            'email': newUser.email,
            'bursaryUrl': newUser.bursaryUrl,
            'deptUrl': newUser.deptUrl,
            'healthUrl': newUser.healthUrl,
            'libraryUrl': newUser.libraryUrl,
          }));
      _users[userInfo] = newUser;
      notifyListeners();
    } else {
      null;
    }
  }
}
