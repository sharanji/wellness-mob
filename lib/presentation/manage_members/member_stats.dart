import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/components/charts/past_24_hours_chart.dart';
import 'package:wellness/presentation/components/charts/percentage_mode.dart';

class MemberStats extends StatefulWidget {
  const MemberStats({super.key, required this.memberId, required this.memberDetail});
  final String memberId;
  final dynamic memberDetail;

  @override
  State<MemberStats> createState() => _MemberStatsState();
}

class _MemberStatsState extends State<MemberStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memberDetail['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Past24HoursData(userId: widget.memberId),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Memeber Tacking Mode : ',
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PercentageandMode(userId: widget.memberId),
        ],
      ),
    );
  }
}
