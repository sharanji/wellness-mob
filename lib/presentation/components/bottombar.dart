import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/dashboards/comman_dashboard.dart';
import 'package:wellness/presentation/manage_members/manage_members.dart';
import 'package:wellness/presentation/settings/settings_page.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, this.navIndex = 0});
  final int navIndex;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).cardColor,
        index: Get.find<AuthController>().navIndex.value,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.mode_of_travel),
            label: 'Your Mode',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.monitor),
            label: 'Monitor',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          Get.find<AuthController>().navIndex.value = index;
        },
      ),
    );
  }
}
