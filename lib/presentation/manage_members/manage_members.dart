// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/members_controller.dart';
import 'package:wellness/services/add_members.dart';
import 'package:wellness/presentation/components/bottombar.dart';
import 'package:wellness/presentation/manage_members/member_stats.dart';
import 'package:wellness/values/app_constants.dart';
import 'package:wellness/values/app_strings.dart';
import 'package:intl/intl.dart';

class ManageMembers extends StatefulWidget {
  const ManageMembers({super.key});

  @override
  State<ManageMembers> createState() => _ManageMembersState();
}

class _ManageMembersState extends State<ManageMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Monitor Members',
            ),
            actions: const [
              IconButton(
                onPressed: AddMember.addNewMember,
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('track_request')
                      .where('trackerAdminId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Requested Members',
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...snapshot.data!.docs.map((req) {
                                return Container(
                                  width: 250,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(req['reportingMember'].toString()),
                                      Text(
                                        "Requested : " + formatTimestamp(req['timestamp'].toDate()),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Connected Members',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('trackable_users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.data() != null) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ...snapshot.data!.data()!['members'].map((member) {
                              return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(member)
                                      .get(),
                                  builder: (context, memberSnapshot) {
                                    if (memberSnapshot.hasData &&
                                        memberSnapshot.data!.data() != null) {
                                      var memberDetail = memberSnapshot.data!.data();
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => MemberStats(
                                              memberId: member,
                                              memberDetail: memberDetail,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Theme.of(context).cardColor,
                                            // border: Border.all(
                                            //     color: Color.fromARGB(255, 180, 180, 180)),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                foregroundImage:
                                                    NetworkImage(memberDetail!['photoUrl']),
                                              ),
                                              const SizedBox(width: 15),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(memberDetail['name']),
                                                  Text(
                                                      'Last Active: ${DateFormat('h:m a - d MMMM').format(memberDetail['last_active'].toDate())}'),
                                                ],
                                              ),
                                              const Spacer(),
                                              const Icon(Icons.info_outline)
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return const CupertinoActivityIndicator();
                                  });
                            }),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.data() == null) {
                      return const SizedBox(
                        height: 80,
                        child: Center(child: Text("No Members Found")),
                      );
                    }
                    return const CupertinoActivityIndicator();
                  },
                )),

                // Card(
                //   color: Color.fromARGB(255, 127, 202, 255),
                //   child: ListTile(
                //     onTap: addNewMember,
                //     title: const Text(
                //       'Add New Member',
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //     trailing: const Icon(
                //       Icons.add,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    // var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(timestamp);
  }
}
