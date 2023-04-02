import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

class User with ChangeNotifier {
  final String? id;
  final String studentType;
  final String name;
  final String email;
  final String phoneNumber;
  final bursaryUrl;
  final deptUrl;
  final healthUrl;
  final libraryUrl;
  final String department;
  bool isDepartmentCheck;
  bool isFacultyCheck;
  bool isStudentAffairsCheck;
  bool isBursaryCheck;
  bool isTechnologistCheck;
  bool ischiefAuditCheck;
  bool isLibraryCheck;
  bool isAlumniCheck;

  User(
      {required this.id,
      required this.studentType,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.bursaryUrl,
      required this.deptUrl,
      required this.healthUrl,
      required this.libraryUrl,
      required this.department,
      this.isDepartmentCheck = false,
      this.isAlumniCheck = false,
      this.isFacultyCheck = false,
      this.ischiefAuditCheck = false,
      this.isBursaryCheck = false,
      this.isLibraryCheck = false,
      this.isTechnologistCheck = false,
      this.isStudentAffairsCheck = false});

  void _setValue(bool newValue) {
    isDepartmentCheck = newValue;
    notifyListeners();
  }

  void toggleCheckStatus() async {
    final oldStatus = isDepartmentCheck;
    isDepartmentCheck = !isDepartmentCheck;

    notifyListeners();
    final url =
        'https://aaua-e-clearance-default-rtdb.firebaseio.com/clearance/$id.json';
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'isDepartmentCheck': isDepartmentCheck,
          }));
      if (response.statusCode >= 400) {
        _setValue(
          oldStatus,
        );
      }
    } catch (error) {
      _setValue(
        oldStatus,
      );
    }
  }
}
