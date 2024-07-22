import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/auth_controller.dart';

class ProfileInfoCard extends StatelessWidget {
  ProfileInfoCard({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      width: double.infinity,

      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // gradient: LinearGradient(colors: [
        //   Color.fromARGB(255, 67, 149, 255),
        //   Color.fromARGB(255, 91, 160, 251),
        //   Color.fromARGB(255, 0, 140, 255),
        // ]),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 230,
                child: Text(
                  authController.userName.value.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 230,
                child: Text(
                  authController.currentUser!.value.email!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(authController.currentUser!.value.photoURL ??
                'https://static.vecteezy.com/system/resources/thumbnails/029/364/950/small/3d-carton-of-boy-going-to-school-ai-photo.jpg'),
          ),
        ],
      ),
    );
  }
}
