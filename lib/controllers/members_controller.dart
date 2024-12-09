import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/auth_controller.dart';

class MembersController extends GetxController {
  void addTrackingRequest(String newMemberEmail) async {
    var isExisit = await FirebaseFirestore.instance
        .collection('track_request')
        .where('trackerAdminId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('reportingMember', isEqualTo: newMemberEmail)
        .get();
    if (isExisit.size == 0) {
      FirebaseFirestore.instance.collection('track_request').add({
        'trackerAdminId': FirebaseAuth.instance.currentUser!.uid,
        'reportingMember': newMemberEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    Get.back();
    Get.snackbar(
      'Resquest Sent',
      'Your Tracking Request has been Registered',
      backgroundColor: Colors.white,
    );
  }

  void chnageMode(doc) async {
    final AuthController authController = Get.find<AuthController>();
    int interval = doc['interval'];

    if (doc['interval'] == 0) {
      final formKey = GlobalKey<FormState>();
      await Get.defaultDialog(
          title: "How Alerts Per day ?",
          titleStyle: const TextStyle(fontSize: 16),
          content: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    try {
                      int val = int.parse(value!);
                      if (val <= 0) {
                        throw "";
                      }
                    } catch (e) {
                      return 'Enter valid Number';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    if (formKey.currentState!.validate()) {
                      interval = int.parse(val);
                    }
                  },
                ),
              )
            ],
          ),
          barrierDismissible: false,
          onConfirm: () async {
            if (formKey.currentState!.validate()) {
              Navigator.of(Get.context!).pop();
            }
          });
    }

    if (interval > 0) {
      authController.userDetails['mode_name'] = doc['mode_name'];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.currentUser!.value.uid)
          .update({'mode_name': doc['mode_name'], 'alert_interval': interval});
    }
  }
}
