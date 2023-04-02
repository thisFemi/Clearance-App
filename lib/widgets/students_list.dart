import 'package:clearanceapp/providers/users.dart';
import 'package:clearanceapp/widgets/student_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsList extends StatelessWidget {
  final bool showUncleared;
  const StudentsList(this.showUncleared);

  @override
  Widget build(BuildContext context) {
    final studentsdata = Provider.of<Users>(context);
    final students =
        showUncleared ? studentsdata.clearedStudents : studentsdata.users;
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: students.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: students[i],
        child: StudentItem(),
      ),
    );
  }
}
