import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wellness/values/app_constants.dart';
import 'package:wellness/values/app_strings.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map profileValues = {};
  bool isVerifed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Mobile Number")),
      body: Form(
        key: _formKey,
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                initialValue: FirebaseAuth.instance.currentUser!.phoneNumber,
                decoration: InputDecoration(
                  label: Text('Whatsapp Number'),
                ),
                keyboardType: TextInputType.number,
                onSaved: (newValue) => profileValues['number'] = newValue,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('cancel'),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();

                      // await FirebaseAuth.instance.currentUser!
                      //     .updatePassword(profileValues['password']);
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(profileValues['name']);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isVerifed
                          ? const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
