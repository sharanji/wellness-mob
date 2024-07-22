import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/values/app_theme_2.dart';

class InfoListScreen extends StatelessWidget {
  const InfoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              'Parental Tracking Request',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.2,
                color: DesignAppTheme.grey,
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('track_request')
                    .where('reportingMember', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Column(
                      children: snapshot.data!.docs.map((req) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 2,
                                color: Color.fromARGB(255, 221, 221, 221),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                HexColor('#e5ebff'),
                                Colors.white,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(255, 235, 235, 235),
                            ),
                          ),
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(req['trackerAdminId'])
                                .get(),
                            builder: (context, adminData) {
                              if (!adminData.hasData) {
                                return const Text('---');
                              }

                              var adminDetails = adminData.data!.data()!;

                              return Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: Color.fromARGB(255, 105, 205, 255),
                                    ),
                                    child: const Icon(Icons.monitor_heart),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'You have a Track Reuest From : ',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        adminDetails['email'],
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      var trackableUsers = await FirebaseFirestore.instance
                                          .collection('trackable_users')
                                          .doc(req['trackerAdminId'])
                                          .get();

                                      print(req['trackerAdminId']);

                                      if (trackableUsers.data() == null) {
                                        await FirebaseFirestore.instance
                                            .collection('trackable_users')
                                            .doc(req['trackerAdminId'])
                                            .set({
                                          'members': [FirebaseAuth.instance.currentUser!.uid]
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection('trackable_users')
                                            .doc(req['trackerAdminId'])
                                            .update({
                                          'members': FieldValue.arrayUnion(
                                              [FirebaseAuth.instance.currentUser!.uid])
                                        });
                                      }

                                      await FirebaseFirestore.instance
                                          .collection('track_request')
                                          .doc(req.id)
                                          .delete();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                      child: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('track_request')
                                          .doc(req.id)
                                          .delete();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const SizedBox(
                    height: 100,
                    child: Center(child: Text('No Requests found')),
                  );
                }),
            const Text(
              'Alert Notifications',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.2,
                color: DesignAppTheme.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user_notifications')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('notifications')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        int i = 0;
                        return Column(
                          children: [
                            ...snapshot.data!.docs.map((notification) {
                              i += 1;
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: i & 1 == 0
                                          ? Theme.of(context).cardColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: Icon(
                                            Icons.notifications,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(notification['message']),
                                        const Spacer(),
                                        GestureDetector(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection('user_notifications')
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .collection('notifications')
                                                  .doc(notification.id)
                                                  .delete();
                                            },
                                            child: const Icon(Icons.clear)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        );
                      }
                      return const SizedBox(
                        child: Center(child: Text('No Notifications Found')),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
