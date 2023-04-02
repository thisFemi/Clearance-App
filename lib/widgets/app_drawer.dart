import 'package:clearanceapp/models/utils/Common.dart';
import 'package:flutter/material.dart';

import '../models/utils/Colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  'Dr Adubuola Femi',
                  style: TextStyle(color: color7, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Faculty officer',
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
                buildListTile('Complants/Enquires', Icons.info_outline_rounded,
                    () => null),
                buildListTile('SignOut', Icons.logout, () => null)
              ],
            ),
          )
        ],
      ),
    );
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
}
