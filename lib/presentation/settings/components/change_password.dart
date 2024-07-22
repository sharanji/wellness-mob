import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';

  const ChangePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

enum SingingCharacter { lafayette, jefferson }

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // List<Logindetails> accounts = objectbox.authUsers.getAll();
  bool hidePasswordCurrent = true;
  bool hidePasswordnew = true;
  bool hidePasswordre = true;
  bool _currentPw = false;
  var oldPassword, newPassword;

  final TextEditingController _currentpswd = TextEditingController();
  final TextEditingController _newpswd = TextEditingController();
  final TextEditingController _newconfpswd = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideNewConPassword = true;
  FocusNode myFocusNode = FocusNode();

  bool _disable = true;
  bool _currentDisable = true;
  bool _newDisable = true;

  // _currentPassword(var data) async {
  //   var response = await ChangePasswordRepository.getCurrentPassword(data);
  //   if (!response) {
  //     setState(() {
  //       _currentPw = false;
  //       _currentDisable = true;
  //     });
  //   } else {
  //     setState(() {
  //       _currentPw = true;
  //       _currentDisable = false;
  //     });
  //   }
  // }

  void _savePassword(BuildContext context) async {
    // FirebaseAuth.instance
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              color: Colors.blue.shade50,
              elevation: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        // enableInteractiveSelection: false,
                        controller: _currentpswd,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: hidePasswordCurrent,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Current Password',
                          labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                hidePasswordCurrent = !hidePasswordCurrent;
                              });
                            },
                            icon: Icon(
                              hidePasswordCurrent ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Current Password';
                          } else if (!_currentPw) {
                            return 'Current password does not match';
                          } else if (value.length < 6) {
                            return 'Password must be atleast 6 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // _currentPassword(value);
                        },
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        // enableInteractiveSelection: false,
                        controller: _newpswd,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: hidePasswordnew,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'New Password',
                          labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                hidePasswordnew = !hidePasswordnew;
                              });
                            },
                            icon: Icon(
                              hidePasswordnew ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter New Password';
                          } else if (value == _currentpswd.text) {
                            return 'Password shouldn\'t be same as current password';
                          } else if (value.length < 6) {
                            return 'Password must be atleast 6 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length > 6) {
                            setState(() {
                              _newDisable = false;
                            });
                          } else {
                            setState(() {
                              _newDisable = true;
                            });
                          }
                        },
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        // enableInteractiveSelection: false,
                        controller: _newconfpswd,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(color: Colors.black),
                        obscureText: hidePasswordre,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Re Enter Password',
                          labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                hidePasswordre = !hidePasswordre;
                              });
                            },
                            icon: Icon(
                              hidePasswordre ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Re-Enter Password';
                          } else if (_newpswd.text != _newconfpswd.text) {
                            return 'Password does not match';
                          } else if (value.length < 5) {
                            return 'Password must be atleast 6 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value == _newpswd.text) {
                            setState(() {
                              _disable = false;
                            });
                          } else {
                            setState(() {
                              _disable = true;
                            });
                          }
                        },
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 60,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: !_disable && !_newDisable && !_currentDisable
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _savePassword(context);
                                    }
                                  }
                                : () {
                                    print('1212');
                                  },
                            child: Container(
                              width: 60,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !_disable && !_newDisable && !_currentDisable
                                    ? Theme.of(context).primaryColor
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
