import 'package:cloud_firestore/cloud_firestore.dart';

class OfficerModel {
  String? uId;
  String? fullName;
  String? email;
  String? password;
  String? officerType;

  OfficerModel({
    this.uId,
    this.email,
    this.fullName,
   this.password,
   this.officerType,
  });

  toJson() {
    return {
      'FullName': fullName,
      'Officer Type': officerType,
      'Email': email,
      'Password': password
    };
  }

  factory OfficerModel.fromMap(map) {
    return OfficerModel(
        uId: map['uId'],
        email: map['email'],
        fullName: map["fullname"],
        password: map["password"],
        officerType: map["officerType"]);
  } 

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'email': email,
      'fullname': fullName,
      'officerType': officerType
    };
  }
}
