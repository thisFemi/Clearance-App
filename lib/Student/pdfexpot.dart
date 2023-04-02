// class PdfPreviewPage extends StatelessWidget {
//   const PdfPreviewPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PdfPreview(build: (context) => makePdf()),
//     );
//   }
// }
import 'package:flutter/services.dart';
import 'package:clearanceapp/providers/user.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf(User user) async {
  final Document pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());
  pdf.addPage(Page(build: (Context context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image(imageLogo),
            ),
            Spacer(),
            Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Text('ADEKUNLE AJASIN UNIVERSITY, AKUNGBA-AKOKO',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('PMB 001, AKUNGBA-AKOKO, ONDO STATE OF NIGERIA',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('2021/2022 OFFICIAL CLEARANCE REPORT',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ]))
          ],
        ),
        Divider(
          height: 2,
        ),
        Center(
          child: Text(user.name,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        SizedBox(height: 20),
        Text(
          'PERSONAL INFORMATION',
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Column(children: [
                    Row(children: [
                      Text("Matric Number: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(user.id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Row(children: [
                      Text("Faculty ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'SCIENCE',
                      ),
                    ]),
                    Row(children: [
                      Text("Academic Session: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '2021/2022',
                      ),
                    ])
                  ])),
                  Container(
                      child: Column(children: [
                    Row(children: [
                      Text("Mode of Entry :",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        user.studentType.toString().toUpperCase(),
                      )
                    ]),
                    Row(children: [
                      Text("Course of Study : ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        user.department.toUpperCase(),
                      ),
                    ]),
                    Row(children: [
                      Text("Contact : ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        user.phoneNumber + ' / ' + user.email,
                      ),
                    ])
                  ]))
                ])),
        SizedBox(height: 10),
        Text(
          'CLEARANCE INFORMATION',
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Table(border: TableBorder.all(color: PdfColors.black), children: [
          TableRow(
              children: [Center(child: Text('CLEARANCE APPROVAL BREAKDOWN'))]),
        ]),
        Table(border: TableBorder.all(color: PdfColors.black), children: [
          TableRow(children: [
            Expanded(child: PaddedText('DEPARTMENT'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('FACULTY'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('STUDENT AFFAIRS'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('BURSARY'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('HEALTH-CENTER'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('LIBRARY'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('ALUMNI'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ]),
          TableRow(children: [
            Expanded(child: PaddedText('CHIEF-AUDITOR'), flex: 2),
            Expanded(
              child: PaddedText('Approved'),
              flex: 1,
            ),
          ])
        ])
      ],
    );
  }));
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
