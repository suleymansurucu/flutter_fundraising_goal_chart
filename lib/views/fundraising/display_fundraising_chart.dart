import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_gauge_indicator.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:provider/provider.dart';

class DisplayFundraisingChart extends StatefulWidget {
  final String fundraisingID;
  final String userID;
  String? communityName;
  double? fundraisingTarget = 0;
  late double totalDonated;

  DisplayFundraisingChart(
      {super.key, required this.fundraisingID, required this.userID});

  @override
  State<DisplayFundraisingChart> createState() =>
      _DisplayFundraisingChartState();
}

class _DisplayFundraisingChartState extends State<DisplayFundraisingChart> {
  FundraisingModel? fundraisingData;
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300), // Yumuşak kaydırma
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTop();
    });
  }

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
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
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
                  height: 10,
                ),
                Divider(
                  color: Constants.primary,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.communityName.toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Constants.primary),
                              ),
                              /* BuildPieChart(
                                  targetProgress:
                                      donationViewModels.targetProgress,
                                  fundraisingTarget:
                                      widget.fundraisingTarget ?? 0,
                                  totalDonated:
                                      donationViewModels.totalDonated),*/

                              BuildGaugeIndicator(
                                  fundraisingTarget: widget.fundraisingTarget ?? 0,
                                  totalDonated: donationViewModels.totalDonated,
                                  targetProgress: donationViewModels
                                      .targetProgress),


                              getCommunities(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: Constants.primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Text(
                                  'Last Donor',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Selector<DonationViewModels, List<DonationModel>>(
                                selector: (_, viewModel) => viewModel.donations,
                                builder: (context, donations, child) {
                                  if (donations.isEmpty) {
                                    return Center(
                                        child: Text("No donations yet."));
                                  }
                                  return Expanded(
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.all(8),
                                      itemCount: donations.length,
                                      itemBuilder: (context, index) {
                                        final DonationModel donation =
                                        donations[index];
                                        return Card(
                                          color: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                              Constants.primary,
                                              child: Text(
                                                '${donations.length-index}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            title: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(donation.donorName),
                                                Text(
                                                    "\$${donation
                                                        .donationAmount}")
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
    var target = await fundraisingViewModels.getAllFundraiserTarget(
        widget.userID, widget.fundraisingID);
    debugPrint('Gormek istedigim ${snapshot.toString()}');
    debugPrint('Fundraising Graphic Type: ${snapshot!.graphicType}');
    debugPrint('Fundraising Unique Name: ${snapshot!.uniqueName}');
    debugPrint(snapshot!.currency);
    debugPrint('Get Fundraising Screen');
    setState(() {
      fundraisingData = snapshot;
      widget.fundraisingTarget = target;
      widget.communityName = snapshot.uniqueName;
    });
  }

  Widget getCommunities() {
    final FundraisingViewModels fundraisingViewModels =
    Provider.of<FundraisingViewModels>(context, listen: false);

    return FutureBuilder<FundraisingModel?>(
      future: fundraisingViewModels.getFundraiser(
          widget.userID, widget.fundraisingID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Widget> buttons = snapshot.data!.communities.map((community) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: snapshot.data!.communities.length == 1
                ? SizedBox()
                : BuildElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.communityName = community.name;
                    widget.fundraisingTarget = community.goal;
                  });
                },
                buttonText: community.name,
                buttonColor: Colors.grey.shade300,
                textColor: Constants.textColor),
          );
        }).toList();

        if (snapshot.data!.communities.length > 1) {
          buttons.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: BuildElevatedButton(
                onPressed: () async {
                  var allTarget =
                  await fundraisingViewModels.getAllFundraiserTarget(
                      widget.userID, widget.fundraisingID);
                  setState(() {
                    widget.communityName = snapshot.data!.uniqueName;
                    widget.fundraisingTarget = allTarget;
                  });
                },
                buttonText: 'General',
                buttonColor: Colors.grey.shade300,
                textColor: Constants.textColor),
          ));
        }

        return Wrap(
          spacing: 8.0,
          children: buttons,
        );
      },
    );
  }
}
