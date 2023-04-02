class StudentModel {
  String? uId;
  String? matric;
  String? password;

  StudentModel({this.uId, this.matric, this.password});

  toJson() {
    return {
      'Matric': matric,
      'Password': password,
    };
  }

  factory StudentModel.fromMap(map) {
    return StudentModel(
        uId: map['uId'], password: map['Password'], matric: map['Matric']);
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'Matric': matric,
    };
  }
}
