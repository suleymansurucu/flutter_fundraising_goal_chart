import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class DisplayFundraisingChart extends StatefulWidget {
  final String fundraisingID;
  final String userID;

  const DisplayFundraisingChart(
      {super.key, required this.fundraisingID, required this.userID});

  @override
  State<DisplayFundraisingChart> createState() =>
      _DisplayFundraisingChartState();
}

class _DisplayFundraisingChartState extends State<DisplayFundraisingChart> {
  FundraisingModel? fundraisingData;

  @override
  void initState() {
    super.initState();
    getFundraisingScreen();
    Provider.of<DonationViewModels>(context, listen: false)
        .listenToDonations(widget.userID, widget.fundraisingID);
  }

  @override
  Widget build(BuildContext context) {
    final DonationViewModels donationViewModels =
        Provider.of<DonationViewModels>(context);
    if (fundraisingData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              fundraisingData!.slogan,
              style: TextStyle(
                  fontSize: 40,
                  color: Constants.textColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 700,
                  child: PieChart(
                    dataMap: {
                      'Fundraising Progress': donationViewModels.targetProgress,
                      'Remaining': 100 - donationViewModels.targetProgress,
                    },
                    chartType: ChartType.ring,
                    chartRadius: MediaQuery.of(context).size.width / 3,
                    colorList: [Colors.green, Colors.red],
                    centerText: "${donationViewModels.targetProgress.toStringAsFixed(1)}%",
                    ringStrokeWidth: 64,
                    animationDuration: Duration(milliseconds: 1500),
                    chartLegendSpacing: 32,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                    ),
                    centerTextStyle: TextStyle(fontSize: 50),
                  legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),

                    ),
                  )

                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 700,
                    child: Selector<DonationViewModels, List<DonationModel>>(
                      selector: (_, viewModel) => viewModel.donations,
                      builder: (context, donations, child) {
                        if (donations.isEmpty) {
                          return Center(child: Text("No donations yet."));
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: donations.length,
                            itemBuilder: (context, index) {
                              final DonationModel donation = donations[index];
                              return ListTile(
                                title: Text(donation.donorName),
                                subtitle: Text("\$${donation.donationAmount}"),
                              );
                            },
                          ),
                        );
                      },
                    )),
              ],
            ),
          ],
        ),
      ));
    }
  }

  Future<void> getFundraisingScreen() async {
    final FundraisingViewModels fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    var snapshot = await fundraisingViewModels.getFundraiser(
        widget.userID, widget.fundraisingID);
    debugPrint('Fundraising Graphic Type: ${snapshot!.graphicType}');
    debugPrint('Fundraising Unique Name: ${snapshot!.uniqueName}');
    debugPrint(snapshot!.currency);
    debugPrint('Get Fundraising Screen');
    setState(() {
      fundraisingData = snapshot;
    });
  }
}
