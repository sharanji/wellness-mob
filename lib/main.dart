import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellness/controllers/members_controller.dart';
import 'package:wellness/presentation/auth/login_screen.dart';
import 'package:wellness/presentation/auth/register_screen.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/dashboards/comman_dashboard.dart';
import 'package:wellness/presentation/settings/settings_page.dart';
import 'package:wellness/presentation/template.dart';
import 'package:wellness/providers/theme_provider.dart';
import 'package:wellness/values/app_theme.dart';
import 'firebase_options.dart';

import 'package:workmanager/workmanager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

const screenStatuschannel = MethodChannel('com.example.wellness/screenStatus');

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

// Future<void> initializeWorkManager(userId) async {
//   const platform = MethodChannel('com.example.wellness/workmanager');
//   try {
//     await platform.invokeMethod('initializeWorkManager', {"userId": userId});
//   } on PlatformException catch (e) {
//     print("Failed to initialize WorkManager: '${e.message}'.");
//   }
// }

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Background Task Executed: $task");

    print("This is working");

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (FirebaseAuth.instance.currentUser != null) {
    await screenStatuschannel
        .invokeMethod('startService', {"userId": FirebaseAuth.instance.currentUser!.uid});
    // await initializeWorkManager(FirebaseAuth.instance.currentUser!.uid);
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ThemeProvider(),
      builder: (context, child) => GetMaterialApp(
        title: 'Wellness check',
        themeMode:
            Provider.of<ThemeProvider>(context).isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.themeData,
        darkTheme: AppDarkTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          CommanDashboard.routeName: (_) => const AppTemplate(),
          RegisterPage.routeName: (_) => const RegisterPage(),
          LoginPage.routeName: (_) => const LoginPage(),
          SettingsPage.routeName: (_) => const SettingsPage(),
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              Get.put(MembersController());
              if (snapshot.hasData && snapshot.data!.email != null) {
                return const AppTemplate();
              }
              return const LoginPage();
            }),
      ),
    );
  }
}
