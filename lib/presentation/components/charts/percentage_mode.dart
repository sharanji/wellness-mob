import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wellness/controllers/auth_controller.dart';
import 'package:wellness/presentation/components/charts/past_24_hours_chart.dart';

class PercentageandMode extends StatelessWidget {
  const PercentageandMode({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    Timestamp timestamp24HoursAgo = Timestamp.fromDate(yesterday);
    List<dynamic> snapShotData = [];
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (ctx, userInfosnapshot) {
          if (userInfosnapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          }
          var userInfo = userInfosnapshot.data!.data();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 180,
                    width: (MediaQuery.of(context).size.width / 2) - 30,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('screen_status')
                                .doc(userId)
                                .collection('records')
                                .where('timestamp', isGreaterThan: timestamp24HoursAgo)
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 150,
                                  child: Center(child: CupertinoActivityIndicator()),
                                );
                              }

                              // snapShotData = snapshot.data!.data()!['records'] ?? [];
                              if (snapshot.data != null) {
                                snapShotData =
                                    snapshot.data!.docs.map((data) => data.data()).toList();
                              }
                              snapShotData
                                  .add({'status': "Screen On", 'timestamp': Timestamp.now()});

                              Duration totalScreenTime = calculateScreenOnTime(snapShotData);

                              return SizedBox(
                                height: 150,
                                child: SfCircularChart(
                                  key: GlobalKey(),
                                  series: _getRadialBarDefaultSeries(totalScreenTime.inMinutes),
                                  annotations: [
                                    CircularChartAnnotation(
                                      widget: Text('${totalScreenTime.inMinutes} Mins'),
                                    )
                                  ],
                                ),
                              );
                            }),
                        const Text(
                          '24 Hour Screen Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<AuthController>().navIndex.value = 1;
                    },
                    child: Container(
                      height: 180,
                      width: (MediaQuery.of(context).size.width / 2) - 30,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('tracking_modes')
                              .where('mode_name', isEqualTo: userInfo!['mode_name'])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 80,
                                    child: Image.network(snapshot.data!.docs.first.data()['icon']),
                                  ),
                                  Text(
                                    snapshot.data!.docs.first.data()['mode_name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              );
                            }

                            return const CupertinoActivityIndicator();
                          }),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Sleep Analytics',
                  style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                // height: 100,
                // width: MediaQuery.of(context).size.width / 1.11,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 150,
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }

                      bool sleepStartAm = true;
                      bool sleepEndAm = true;

                      var actsleepStart = snapshot.data.data()['sleepStart'].isNaN
                          ? 0
                          : snapshot.data.data()['sleepStart'];
                      var actsleepEnd = snapshot.data.data()['sleepEnd'].isNaN
                          ? 0
                          : snapshot.data.data()['sleepEnd'];

                      // Fetch and round the sleep start and end times
                      var sleepStart = (actsleepStart).round();
                      if (sleepStart > 12) {
                        sleepStartAm = false;
                      }
                      if (sleepStart > 12) {
                        sleepStart -= 12;
                      }

                      var sleepEnd = (actsleepEnd).round();

                      if (sleepEnd > 12) {
                        sleepEndAm = false;
                      }
                      if (sleepEnd > 12) {
                        sleepEnd -= 12;
                      }

                      dynamic sleepDuration;
                      if (actsleepStart > actsleepEnd) {
                        sleepDuration = (24 - actsleepStart) + actsleepEnd;
                      } else {
                        sleepDuration = actsleepEnd - actsleepStart;
                      }

                      if (sleepDuration == 0) {
                        return const SizedBox(
                          height: 50,
                          child: Center(child: Text('No Sufficient Data for Sleeping Time')),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: SfCircularChart(
                              key: GlobalKey(),
                              series: _getSleepRadialChart(sleepDuration),
                              annotations: [
                                CircularChartAnnotation(
                                  widget: Text('${sleepDuration.round()} Hours'),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Avg Sleep Time : ${sleepStart.toString().padLeft(2, '0')}:00 ${sleepStartAm ? 'AM' : 'PM'}',
                              ),
                              Text(
                                'Avg Wake At: ${sleepEnd.toString().padLeft(2, '0')}:00 ${sleepEndAm ? 'AM' : 'PM'}',
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        });
  }

  Duration calculateScreenOnTime(List events) {
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

    return totalOnTime;
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries(yValue) {
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
          maximumValue: 100,
          dataLabelSettings:
              const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 10.0)),
          dataSource: <ChartSampleData>[
            ChartSampleData(
              x: '',
              y: yValue / 6,
              text: '100%',
              pointColor: const Color.fromRGBO(248, 177, 149, 1.0),
            ),
          ],
          cornerStyle: CornerStyle.bothCurve,
          gap: '60%',
          radius: '100%',
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointRadiusMapper: (ChartSampleData data, _) => data.text,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String)
    ];
  }

  List<RadialBarSeries<ChartSampleData, String>> _getSleepRadialChart(yValue) {
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
          maximumValue: 10,
          dataLabelSettings:
              const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 10.0)),
          dataSource: <ChartSampleData>[
            ChartSampleData(
              x: '',
              y: yValue,
              text: '100%',
              pointColor: const Color.fromRGBO(248, 177, 149, 1.0),
            ),
          ],
          cornerStyle: CornerStyle.bothCurve,
          gap: '60%',
          radius: '100%',
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointRadiusMapper: (ChartSampleData data, _) => data.text,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String)
    ];
  }
}

class ChartSampleData {
  dynamic x;
  dynamic y;
  dynamic text;
  dynamic pointColor;
  ChartSampleData({this.x, this.y, this.text, this.pointColor});
}
