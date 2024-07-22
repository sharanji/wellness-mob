import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wellness/services/add_members.dart';
import 'package:wellness/presentation/manage_members/manage_members.dart';
import 'package:wellness/presentation/settings/settings_page.dart';
import 'package:wellness/values/app_theme_2.dart';

class QucikActions extends StatefulWidget {
  const QucikActions({super.key});

  @override
  State<QucikActions> createState() => _QucikActionsState();
}

class _QucikActionsState extends State<QucikActions> {
  final List<Map> categoryList = [
    {
      'title': 'Send Quick Message',
      'action': AddMember.sendMessage,
      'iconPath': 'assets/message.png'
    },
    {'title': 'Add Memebers', 'action': AddMember.addNewMember, 'iconPath': 'assets/add_user.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5.0, left: 10, right: 16),
          child: Text(
            'Quick Actions',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.27,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          // height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: [
              for (int i = 0; i < categoryList.length; i++)
                Column(
                  children: [
                    GestureDetector(
                      onTap: categoryList[i]['action'],
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Color.fromARGB(255, 105, 205, 255),
                              ),
                              child: Image.asset(
                                categoryList[i]['iconPath'],
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              categoryList[i]['title'],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 30,
                              child: Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).cardColor,
                    ),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }
}
