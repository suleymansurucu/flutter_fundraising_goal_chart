import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_linear_chart.dart';
import 'package:pie_chart/pie_chart.dart';

class BuildPieChart extends StatefulWidget {
  double targetProgress;
  double fundraisingTarget;
  double totalDonated;

  BuildPieChart(
      {required this.targetProgress,
      required this.fundraisingTarget,
      required this.totalDonated,
      super.key});

  @override
  State<BuildPieChart> createState() => _BuildPieChartState();
}

class _BuildPieChartState extends State<BuildPieChart> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        BuildLinearChart(
            fundraisingTarget: widget.fundraisingTarget,
            totalDonated: widget.totalDonated,
            targetProgress: widget.targetProgress),
        SizedBox(height: screenHeight * 0.06),
        Stack(alignment: Alignment.center, children: [
          PieChart(
            dataMap: {
              'Fundraising Progress': widget.targetProgress,
              'Remaining': 100 - widget.targetProgress,
            },
            chartType: ChartType.ring,
            chartRadius:screenHeight * 0.5,
            colorList: [Colors.green, Colors.red],
            //centerText: "${donationViewModels.targetProgress.toStringAsFixed(1)}%",
            ringStrokeWidth: 64,
            animationDuration: Duration(milliseconds: 1500),
            chartLegendSpacing: 32,
            chartValuesOptions: ChartValuesOptions(
              showChartValues: false,
              showChartValuesInPercentage: false,
            ),
            centerTextStyle: TextStyle(fontSize: 50),
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.bottom,
              showLegends: false,
              legendTextStyle:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            child: Text(
              '${widget.targetProgress.toStringAsFixed(1)}%',
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
        ]),
      ]),
    );
  }
}
