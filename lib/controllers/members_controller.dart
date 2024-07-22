import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
