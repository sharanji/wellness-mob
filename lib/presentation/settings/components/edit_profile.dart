import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wellness/values/app_constants.dart';
import 'package:wellness/values/app_regex.dart';
import 'package:wellness/values/app_strings.dart';
import 'package:country_picker/country_picker.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _numberController = TextEditingController();
  String countryCode = '';

  bool isVerifed = true;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        countryCode = value.data()!['country_code'] ?? '91';
        _numberController.text = value.data()!['whatsapp_number'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Mobile Number")),
      body: Form(
        key: _formKey,
        child: Container(
          height: 170,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true, // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          setState(() {
                            countryCode = country.phoneCode;
                          });
                        },
                      );
                    },
                    child: Container(
                      width: 70,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 130, 130, 130)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(countryCode),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: TextFormField(
                      controller: _numberController,
                      decoration: const InputDecoration(
                        label: Text('Whatsapp Number'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (!AppRegex.mobileNumber.hasMatch(val!)) {
                          return "Invalid Mobile Number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'whatsapp_number': _numberController.text,
                        'country_code': countryCode
                      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Saved Successfully!'),
                                ),
                              ));
                      Navigator.of(context).pop();
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
