import 'package:clearanceapp/Admin/Officers/busrary.dart';
import 'package:clearanceapp/Admin/admin_dashboard.dart';
import 'package:clearanceapp/Admin/approval_screen.dart';
import 'package:clearanceapp/Student/student_dashboard.dart';
import 'package:clearanceapp/Student/student_login.dart';
import 'package:clearanceapp/Student/student_upload.dart';

import 'package:clearanceapp/providers/users.dart';

import 'package:clearanceapp/screens/init/main_screen.dart';
import 'package:clearanceapp/screens/init/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Admin/Officers/alumni.dart';
import 'Admin/Officers/department_screen.dart';
import 'Admin/Officers/faculty_screen.dart';
import 'Admin/Officers/healthCenter.dart';
import 'Admin/Officers/library.dart';
import 'Student/student_register.dart';
import 'firebase_options.dart';
import 'models/utils/Colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Users(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AAUA E-Clerance',
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: MaterialColor(0xFF030303, color),
        ),
        home: SplashScreen(),
        routes: {
          StudentUpload.routeName: (ctx) => StudentUpload(),
          StudentDashboard.routeName: (ctx) => StudentDashboard(),
          ApprovalScreen.routeName: (ctx) => ApprovalScreen(),
          MainScreen.routeName: (ctx) => MainScreen(),
          StudentCheck.routeName: (ctx) => StudentCheck(),
          AdminDashoard.routeName: (ctx) => AdminDashoard(),
          DepartmentalScreen.routeName: (ctx) => DepartmentalScreen(),
          FacultyScreen.routeName: (ctx) => FacultyScreen(),
          StudentRegister.routeName: (ctx) => StudentRegister(),
          AlumniOffice.routeName: (ctx) => AlumniOffice(),
          LibraryOffice.routeName: (ctx) => LibraryOffice(),
          BursaryOffice.routeName: (ctx) => BursaryOffice(),
          HealthOffice.routeName: (ctx) => HealthOffice()
        },
      ),
    );
  }

  Map<int, Color> color = {
    50: color1,
    100: color1,
    200: color1,
    300: color1,
    400: color1,
    500: color1,
    600: color1,
    700: color1,
    800: color1,
    900: color1,
  };
}
