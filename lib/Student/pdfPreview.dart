import 'package:clearanceapp/Student/pdfexpot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';

import '../providers/user.dart';

class PdfPreviewPage extends StatelessWidget {
  final User user;
  const PdfPreviewPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            child: Text(
          user.name + '_' + user.department + '_' + '2021/2022',
          style: TextStyle(fontSize: 16),
        )),
      ),
      body: PdfPreview(
        build: (context) => makePdf(user),
      ),
    );
  }
}
