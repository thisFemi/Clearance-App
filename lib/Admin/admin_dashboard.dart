import 'dart:math';

import 'package:clearanceapp/models/utils/Colors.dart';
import 'package:clearanceapp/models/utils/Common.dart';
import 'package:clearanceapp/providers/officer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/users.dart';
import '../screens/init/main_screen.dart';

import '../widgets/students_list.dart';

class AdminDashoard extends StatefulWidget {
  static const routeName = '/adm-dashboard';
  const AdminDashoard({super.key});

  @override
  State<AdminDashoard> createState() => _AdminDashoardState();
}

enum FilterOptions { UnCleared, All }

class _AdminDashoardState extends State<AdminDashoard> {
  var _showOnlyUnCleared = false;
  final _db = FirebaseFirestore.instance;
  var _showAll = false;

  var _isInit = true;
  var _isLoading = false;

  User? user = FirebaseAuth.instance.currentUser;
  OfficerModel logginInUser = OfficerModel();
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('officers')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.logginInUser = OfficerModel.fromMap(value.data());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [Text('${logginInUser.fullName}')],
            ),
          ),

          //automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.All) {
                      _showOnlyUnCleared = false;
                    } else {
                      _showOnlyUnCleared = true;
                    }
                  });
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          'Only Cleared Students',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: FilterOptions.UnCleared,
                      ),
                      PopupMenuItem(
                        child: Text(
                          'Show All',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: FilterOptions.All,
                      )
                    ]),
          ],
        ),
        drawer: Drawer(
          //height: displaySize.height,
          backgroundColor: color6,
          width: displaySize.width * .7,

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
                      '${logginInUser.fullName}',
                      style: TextStyle(color: color7, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Officer Type: ${logginInUser.officerType}',
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
                          MainScreen.routeName, (route) => false);
                    })
                  ],
                ),
              )
            ],
          ),
        ),
        body: FutureBuilder(
            future: Provider.of<Users>(context, listen: false)
                .fetchAndSetClearanceOrders(context),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SpinKitThreeBounce(color: color14, size: 40));
              } else {
                if (dataSnapshot.error != null) {
                  return Text('An Error occurred');
                } else {
                  return StudentsList(_showOnlyUnCleared);
                }
              }
            }));
  }
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
