import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/auth_controller.dart';

class ModeScreen extends StatefulWidget {
  const ModeScreen({super.key});

  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tracking Modes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tracking_modes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CupertinoActivityIndicator();
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  var itMode = snapshot.data!.docs[index].data();
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        _authController.userDetails['mode_name'] =
                            snapshot.data!.docs[index]['mode_name'];
                      });

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(_authController.currentUser!.value.uid)
                          .update({'mode_name': snapshot.data!.docs[index]['mode_name']});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: snapshot.data!.docs[index]['mode_name'] ==
                                _authController.userDetails['mode_name']
                            ? Colors.blue
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 80,
                            child: Image.network(itMode['icon']),
                          ),
                          Text(
                            itMode['mode_name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
