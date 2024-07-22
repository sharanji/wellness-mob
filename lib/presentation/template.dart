import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/components/bottombar.dart';
import 'package:wellness/presentation/dashboards/comman_dashboard.dart';
import 'package:wellness/presentation/manage_members/manage_members.dart';
import 'package:wellness/presentation/mode/mode_screen.dart';
import 'package:wellness/presentation/settings/settings_page.dart';

class AppTemplate extends StatelessWidget {
  const AppTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (Get.find<AuthController>().navIndex.value) {
          case 0:
            return const CommanDashboard();
          case 1:
            return const ModeScreen();
          case 2:
            return const ManageMembers();
          case 3:
            return const SettingsPage();

          default:
            return const CommanDashboard();
        }
      }),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
