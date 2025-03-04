import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_linear_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class BuildGaugeIndicator extends StatefulWidget {
  double targetProgress;
  double fundraisingTarget;
  double totalDonated;
  double realTargetProgress;

  BuildGaugeIndicator(
      {required this.fundraisingTarget,
      required this.totalDonated,
      required this.targetProgress,
      required this.realTargetProgress,
      super.key});

  @override
  State<BuildGaugeIndicator> createState() => _BuildGaugeIndicatorState();
}

class _BuildGaugeIndicatorState extends State<BuildGaugeIndicator> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Fundraising Target : ${widget.fundraisingTarget}');
    debugPrint('Toplam Donate : ${widget.totalDonated}');
    debugPrint('Proggress : ${widget.targetProgress}');

    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BuildLinearChart(
          fundraisingTarget: widget.fundraisingTarget,
          totalDonated: widget.totalDonated,
          targetProgress: widget.targetProgress,
          realTargetProgress: widget.realTargetProgress,
        ),
        SizedBox(height: 30.w),
        Expanded(
          child: AnimatedRadialGauge(
            duration: const Duration(seconds: 1),
            curve: Curves.elasticOut,
            value: widget.targetProgress,
            axis: GaugeAxis(
              min: 0,
              max: 100,
              degrees: 180,
              style: GaugeAxisStyle(
                  thickness: 120.w,
                  background: Constants.primary,
                  segmentSpacing: 3),
              pointer: GaugePointer.needle(
                  width: 90.w,
                  height: 800.w,
                  color: Constants.accent,
                  borderRadius: 120.w),
              progressBar: GaugeBasicProgressBar(color: Colors.green),
              segments: [
                const GaugeSegment(
                  from: 0,
                  to: 33.3,
                  color: Colors.red,
                  cornerRadius: Radius.zero,
                ),
                const GaugeSegment(
                  from: 33.3,
                  to: 66.6,
                  color: Colors.red,
                  cornerRadius: Radius.zero,
                ),
                const GaugeSegment(
                  from: 66.6,
                  to: 100,
                  color: Colors.red,
                  cornerRadius: Radius.zero,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 4.w,
        ),
        Text(
          '${widget.realTargetProgress.toStringAsFixed(1)}%',
          style: TextStyle(
              fontSize: 120.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ],
    ));
  }
}
