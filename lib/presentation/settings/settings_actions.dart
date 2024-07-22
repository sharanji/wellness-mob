import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wellness/presentation/settings/components/change_password.dart';
import 'package:wellness/presentation/settings/components/edit_profile.dart';
import 'package:wellness/providers/theme_provider.dart';

class SettingsActions extends StatelessWidget {
  const SettingsActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => EditProfile());
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  'Add Mobile Number',
                  style: TextStyle(
                      // color: Colors.blueGrey,
                      // fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     Get.to(() => const ChangePasswordScreen());
        //   },
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(vertical: 8),
        //     padding: const EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).cardColor,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: const Row(
        //       children: [
        //         Icon(
        //           Icons.person,
        //           color: Colors.blue,
        //         ),
        //         SizedBox(width: 10),
        //         Text(
        //           'Chanage Password',
        //           style: TextStyle(
        //               // color: Colors.blueGrey,
        //               // fontWeight: FontWeight.bold,
        //               ),
        //         ),
        //         Spacer(),
        //         Icon(
        //           Icons.chevron_right,
        //           color: Colors.blue,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.contrast,
                color: Colors.blue,
              ),
              const SizedBox(width: 10),
              const Text(
                'Dark Theme',
                style: TextStyle(
                    // color: Colors.blueGrey,
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) => Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (val) {
                    themeProvider.toggleTheme();
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
