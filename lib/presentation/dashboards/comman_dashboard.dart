import 'package:app_usage_tracker/app_usage_tracker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wellness/presentation/components/bottombar.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/components/charts/past_24_hours_chart.dart';
import 'package:wellness/presentation/dashboards/componets/info_list.dart';
import 'package:wellness/presentation/components/charts/percentage_mode.dart';
import 'package:wellness/presentation/dashboards/componets/profile_infocard.dart';
import 'package:wellness/presentation/dashboards/componets/quick_actions.dart';
import 'package:wellness/values/app_theme_2.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background/flutter_background.dart';

class CommanDashboard extends StatefulWidget {
  const CommanDashboard({super.key});
  static const routeName = "/dashboard";

  @override
  State<CommanDashboard> createState() => _CommanDashboardState();
}

class _CommanDashboardState extends State<CommanDashboard> {
  final AuthController authController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getAppBarUI(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PercentageandMode(userId: FirebaseAuth.instance.currentUser!.uid),
                    getLeastActiveMembers(),
                    // Past24HoursData(userId: FirebaseAuth.instance.currentUser!.uid),
                    const QucikActions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getLeastActiveMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5.0, left: 10, right: 16),
          child: Text(
            'Least Active Members',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.27,
              color: Colors.blueGrey,
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('trackable_users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...snapshot.data!.data()!['members'].map((member) {
                      return FutureBuilder(
                          future: FirebaseFirestore.instance.collection('users').doc(member).get(),
                          builder: (context, memberSnapshot) {
                            if (memberSnapshot.hasData && memberSnapshot.data!.data() != null) {
                              var memberDetail = memberSnapshot.data!.data();
                              // return Text(memberDetail!.toString());
                              return Container(
                                // width: 200,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      foregroundImage: NetworkImage(memberDetail!['photoUrl']),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(memberDetail['name']),
                                        Text(
                                            'Last Active: ${DateFormat('h:m a d-MMMM').format(memberDetail['last_active'].toDate())}'),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    const Icon(Icons.info_outline)
                                  ],
                                ),
                              );
                            }

                            return const CupertinoActivityIndicator();
                          });
                    }),
                  ],
                ),
              );
            }
            if (snapshot.hasData && snapshot.data!.data() == null) {
              return const SizedBox(
                height: 80,
                child: Center(child: Text("No Members Found")),
              );
            }
            return const CupertinoActivityIndicator();
          },
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      decoration: BoxDecoration(
          // color: Theme.of(context).brightness == Brightness.dark
          //     ? Theme.of(context).cardColor
          //     : Theme.of(context).cardColor,
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              SizedBox(width: 150, child: Image.asset('assets/new_logo.png')),
              const Spacer(),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('track_request')
                      .where('reportingMember', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    int count = 0;
                    if (snapshot.hasData) {
                      count = snapshot.data!.docs.length;
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const InfoListScreen());
                      },
                      child: Badge(
                        label: Text(count.toString()),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/notification.png'),
                        ),
                      ),
                    );
                  }),
            ],
          ),
          // ProfileInfoCard(),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 64,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('#F8FAFB'),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(13.0),
                  bottomLeft: Radius.circular(13.0),
                  topLeft: Radius.circular(13.0),
                  topRight: Radius.circular(13.0),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: TextFormField(
                        style: const TextStyle(
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: DesignAppTheme.nearlyBlue,
                        ),
                        keyboardType: TextInputType.text,
                        // focusNode: FocusNode(),
                        decoration: InputDecoration(
                          labelText: 'Search for People , Category , Contacts',
                          border: InputBorder.none,
                          helperStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: HexColor('#B9BABC'),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            color: HexColor('#B9BABC'),
                          ),
                        ),
                        onEditingComplete: () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(Icons.search, color: HexColor('#B9BABC')),
                  )
                ],
              ),
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        )
      ],
    );
  }
}
