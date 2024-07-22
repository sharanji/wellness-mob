import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Past24HoursData extends StatefulWidget {
  const Past24HoursData({super.key, required this.userId});
  final String userId;
  @override
  State<Past24HoursData> createState() => _Past24HoursDataState();
}

class _Past24HoursDataState extends State<Past24HoursData> {
  @override
  Widget build(BuildContext context) {
    return getPast24DataChart();
  }

  Widget getPast24DataChart() {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    Timestamp timestamp24HoursAgo = Timestamp.fromDate(yesterday);
    List<dynamic> snapShotData = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5.0, left: 10, right: 16),
          child: Text(
            '24-hour activity',
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
                .collection('screen_status')
                .doc(widget.userId)
                .collection('records')
                .where('timestamp', isGreaterThan: timestamp24HoursAgo)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              }

              // snapShotData = snapshot.data!.data()!['records'] ?? [];
              if (snapshot.data != null) {
                snapShotData = snapshot.data!.docs.map((data) => data.data()).toList();
              }
              snapShotData.add({'status': "Screen On", 'timestamp': Timestamp.now()});

              final List<ScreenStatusData> fetchedData =
                  snapShotData.map((e) => ScreenStatusData.fromMap(e)).toList();

              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: SfCartesianChart(
                      primaryXAxis: const DateTimeAxis(),
                      series: [
                        StepAreaSeries<ScreenStatusData, DateTime>(
                          // xAxisName: "Lock / Unlock Freq",
                          // yAxisName: 'TimeStamp',
                          dataSource: fetchedData,
                          sortingOrder: SortingOrder.ascending,
                          xValueMapper: (ScreenStatusData data, _) => data.timestamp,
                          yValueMapper: (ScreenStatusData data, _) => data.status,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Screen on Time : ${calculateScreenOnTime(snapShotData)}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
      ],
    );
  }

  String calculateScreenOnTime(List events) {
    events.sort((a, b) {
      return a['timestamp'].toDate().difference(b['timestamp'].toDate()).inSeconds;
    });

    Duration totalOnTime = Duration.zero;

    DateTime? previousDate;
    String? previousStatus;

    for (var event in events) {
      DateTime timestamp = event['timestamp'].toDate();
      String currentStatus = event['status'];

      if (previousDate != null && previousStatus == "Screen On") {
        totalOnTime += timestamp.difference(previousDate);
      }
      previousDate = timestamp;
      previousStatus = currentStatus;
    }

    return formatDuration(totalOnTime);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    // if (duration.inHours > 0) {
    return '$twoDigitHours Hours $twoDigitMinutes Minutes $twoDigitSeconds Seconds';
    // } else {
    //   return '$twoDigitMinutes Minutes:$twoDigitSeconds Seconds';
    // }
  }
}

class ScreenStatusData {
  ScreenStatusData(this.timestamp, this.status);

  final DateTime timestamp;
  final double status;

  factory ScreenStatusData.fromMap(Map<String, dynamic> data) {
    return ScreenStatusData(
      (data['timestamp'] as Timestamp).toDate(),
      data['status'] == 'Screen Off' ? 0 : 1,
    );
  }
}
