import 'dart:core';

import 'package:flutter/material.dart';

class BuildLinearChart extends StatefulWidget {
  double targetProgress;
  double fundraisingTarget;
  double totalDonated;

  BuildLinearChart(
      {required this.fundraisingTarget,
      required this.totalDonated,
      required this.targetProgress,
      super.key});

  @override
  State<BuildLinearChart> createState() => _BuildLinearChartState();
}

class _BuildLinearChartState extends State<BuildLinearChart> {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Reached:',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  '\$${widget.totalDonated.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Goal:',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  '\$${widget.fundraisingTarget.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize:30,
                      fontWeight: FontWeight.w900),
                )
              ],
            )
          ],
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width*0.9,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              LinearProgressIndicator(
                backgroundColor: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(40),
                color: Colors.green,
                minHeight: 20,
                value: widget.targetProgress / 100,
              ),
              Text(
                '${(widget.targetProgress).toInt()}%',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
