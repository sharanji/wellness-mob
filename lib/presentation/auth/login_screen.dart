import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wellness/main.dart';
import 'package:wellness/presentation/auth/register_screen.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/dashboards/comman_dashboard.dart';
import 'package:wellness/presentation/utils/helpers/snackbar_helper.dart';
import 'package:wellness/values/app_regex.dart';

import '../components/app_text_form_field.dart';
import '../../resources/resources.dart';
import '../utils/common_widgets/gradient_background.dart';
import '../utils/helpers/navigation_helper.dart';
import '../../values/app_constants.dart';
import '../../values/app_strings.dart';
import '../../values/app_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email) && AppRegex.passwordRegex.hasMatch(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
    Get.put(AuthController());
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const GradientBackground(
            children: [
              Text(
                AppStrings.signInToYourNAccount,
                style: AppTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text(AppStrings.signInToYourAccount, style: AppTheme.bodySmall),
            ],
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    controller: emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterEmailAddress
                          : AppConstants.emailRegex.hasMatch(value)
                              ? null
                              : AppStrings.invalidEmailAddress;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: AppStrings.password,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? AppStrings.pleaseEnterPassword
                              : AppConstants.passwordRegex.hasMatch(value)
                                  ? null
                                  : AppStrings.invalidPassword;
                        },
                        suffixIcon: IconButton(
                          onPressed: () => passwordNotifier.value = !passwordObscure,
                          style: IconButton.styleFrom(
                            minimumSize: const Size.square(48),
                          ),
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.forgotPassword),
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return FilledButton(
                        onPressed: isValid
                            ? () async {
                                await signinWithEmail();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('userId', FirebaseAuth.instance.currentUser!.uid);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamed(CommanDashboard.routeName);
                                }

                                emailController.clear();
                                passwordController.clear();
                              }
                            : null,
                        child: const Text(AppStrings.login),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade200)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppStrings.orLoginWith,
                          style: AppTheme.bodySmall.copyWith(
                              // color: Colors.black,
                              ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade200)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await signInWithGoogle();
                            if (FirebaseAuth.instance.currentUser != null) {
                              var usercred = FirebaseAuth.instance.currentUser;
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setString('userId', usercred!.uid);
                              FirebaseFirestore.instance.collection('users').doc(usercred.uid).set({
                                'name': usercred.displayName,
                                'email': usercred.email,
                                'photoUrl': usercred.photoURL,
                                'status': 'Daily Routine',
                              }).then(
                                (value) =>
                                    Navigator.of(context).pushNamed(CommanDashboard.routeName),
                              );
                            }
                          },
                          icon: SvgPicture.asset(Vectors.google, width: 25),
                          label: const Text(
                            AppStrings.google,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      // const SizedBox(width: 20),
                      // Expanded(
                      //   child: OutlinedButton.icon(
                      //     onPressed: () async {
                      //       await signInWithGoogle();
                      //       var usercred = FirebaseAuth.instance.currentUser;
                      //       FirebaseFirestore.instance.collection('users').doc(usercred!.uid).set({
                      //         'name': usercred.displayName,
                      //         'email': usercred.email,
                      //         'photoUrl': usercred.photoURL,
                      //       }).then(
                      //         (value) => Navigator.of(context).pushNamed(CommanDashboard.routeName),
                      //       );
                      //     },
                      //     icon: SvgPicture.asset(Vectors.facebook, width: 14),
                      //     label: const Text(
                      //       AppStrings.facebook,
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.doNotHaveAnAccount,
                style: AppTheme.bodySmall.copyWith(),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(
                  RegisterPage.routeName,
                ),
                child: const Text(AppStrings.register),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      await screenStatuschannel
          .invokeMethod('startService', {"userId": FirebaseAuth.instance.currentUser!.uid});
    }
    Get.snackbar(
      'Authentication Success',
      AppStrings.loggedIn,
    );
  }

  Future signinWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (FirebaseAuth.instance.currentUser != null) {
        await screenStatuschannel
            .invokeMethod('startService', {"userId": FirebaseAuth.instance.currentUser!.uid});
      }
      Get.snackbar(
        'Authentication Success',
        AppStrings.loggedIn,
      );
    } on Exception catch (_) {
      Get.snackbar('Authentication Failed', 'Invalid Credentials');
    }
    return null;
  }
}
