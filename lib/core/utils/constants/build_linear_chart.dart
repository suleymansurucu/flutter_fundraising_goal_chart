import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BuildLinearChart extends StatefulWidget {
  double targetProgress;
  double fundraisingTarget;
  double totalDonated;
  double realTargetProgress;

  BuildLinearChart(
      {required this.fundraisingTarget,
      required this.totalDonated,
      required this.targetProgress,
      required this.realTargetProgress,
      super.key});

  @override
  State<BuildLinearChart> createState() => _BuildLinearChartState();
}

class _BuildLinearChartState extends State<BuildLinearChart> {
  @override
  Widget build(BuildContext context) {
    var oCcy = NumberFormat("#,##0.00", "en_US");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Reached:',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  '\$${oCcy.format(widget.totalDonated)}',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.w900),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Goal:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  '\$${oCcy.format(widget.fundraisingTarget)}',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.w900),
                )
              ],
            )
          ],
        ),
        SizedBox(
          //width: double.infinity.w,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              LinearProgressIndicator(
                backgroundColor: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(180.w),
                color: Colors.green,
                minHeight: 60.w,
                value: widget.targetProgress / 100,

              ),
              Text(
                '${widget.realTargetProgress.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 10)]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
