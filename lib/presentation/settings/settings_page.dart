import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/presentation/auth/login_screen.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/components/bottombar.dart';
import 'package:wellness/presentation/dashboards/componets/profile_infocard.dart';
import 'package:wellness/presentation/settings/settings_actions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const routeName = "/settings";

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        width: double.infinity,
        // height: 200,
        margin: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfoCard(),
              const SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const SettingsActions(),
              ),
              const Text(
                'Your Trackers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('trackable_users')
                    .where('members', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("You Have not been Tacked by Anyone");
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...snapshot.data!.docs.map((admin) {
                          return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(admin.id)
                                  .get(),
                              builder: (context, adminData) {
                                if (!adminData.hasData) {
                                  return const CupertinoActivityIndicator();
                                }
                                return Container(
                                  width: 250,
                                  // padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      adminData.data!['name'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(adminData.data!['email'].toString()),
                                  ),
                                );
                              });
                        }),
                      ],
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                margin: EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  tileColor: Colors.transparent,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  onTap: () {
                    authController.auth.signOut();
                    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
                  },
                  title: Text('Logout'),
                  trailing: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
