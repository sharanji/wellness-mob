import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/members_controller.dart';
import 'package:wellness/values/app_constants.dart';
import 'package:wellness/values/app_strings.dart';

import 'package:http/http.dart' as http;

class AddMember {
  static void addNewMember() {
    TextEditingController newMemberController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        child: Container(
          // height: 160,
          // // width: 200,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Enter New Member Email',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: newMemberController,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (val) {},
                  validator: (value) {
                    return value!.isEmpty
                        ? AppStrings.pleaseEnterEmailAddress
                        : AppConstants.emailRegex.hasMatch(value)
                            ? null
                            : AppStrings.invalidEmailAddress;
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;
                  Get.find<MembersController>().addTrackingRequest(newMemberController.text);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Add Member',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void sendMessage() {
    TextEditingController messageController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        child: Container(
          // height: 160,
          // // width: 200,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Enter Text Message',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: messageController,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (val) {},
                  validator: (value) {
                    return value!.isEmpty ? "Enter valid message" : null;
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;
                  var reponse = await http.post(
                    Uri.parse('https://wellness-checker.vercel.app/api/send_message'),
                    body: json.encode(
                      {
                        "parentId": FirebaseAuth.instance.currentUser!.uid,
                        "message": messageController.text
                      },
                    ),
                  );
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
