import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_linear_chart.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class BuildGaugeIndicator extends StatefulWidget {
  double targetProgress;
  double fundraisingTarget;
  double totalDonated;

  BuildGaugeIndicator(
      {required this.fundraisingTarget,
      required this.totalDonated,
      required this.targetProgress,
      super.key});

  @override
  State<BuildGaugeIndicator> createState() => _BuildGaugeIndicatorState();
}

class _BuildGaugeIndicatorState extends State<BuildGaugeIndicator> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BuildLinearChart(
            fundraisingTarget: widget.fundraisingTarget,
            totalDonated: widget.totalDonated,
            targetProgress: widget.targetProgress),
        SizedBox(height: screenHeight * 0.06),
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
                  thickness: screenWidth * 0.03,
                  background: Constants.primary,
                  segmentSpacing: 3),
              pointer: GaugePointer.needle(
                  width: screenWidth * 0.04,
                  height: screenWidth * 0.24,
                  color: Constants.accent,
                  borderRadius: screenWidth * 0.4),
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
          height: screenHeight * 0.05,
        ),
        Text(
          '${widget.targetProgress.toStringAsFixed(1)}%',
          style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),

      ],
    ));
  }
}
