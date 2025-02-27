import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_drop_down_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_gauge_indicator.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_pie_chart.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  bool _isInitialized = false; // İlk başlatma kontrolü

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
    if (!_isInitialized) {
      _initializeData();
      _isInitialized = true; // İlk başlatma tamamlandı
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTop();
    });
  }

  @override
  void didUpdateWidget(DisplayFundraisingChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fundraisingID != widget.fundraisingID) {
      // fundraisingID değiştiğinde yeni verileri dinle
      _initializeData();
    }
  }

  void _initializeData() {
    final FundraisingViewModels fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    fundraisingViewModels.getFundraiser(widget.userID, widget.fundraisingID);
    fundraisingViewModels.getFundraisingScreen(
        widget.userID, widget.fundraisingID);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final donationViewModel =
          Provider.of<DonationViewModels>(context, listen: false);
      donationViewModel.listenToDonations(
          widget.userID,
          widget.fundraisingID,
          fundraisingViewModels.communityName.toString() == null
              ? fundraisingViewModels.communityName.toString()
              : 'general',
          fundraisingViewModels.communityCount?.toInt() ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {

    final DonationViewModels donationViewModels =
        Provider.of<DonationViewModels>(context);
    return Consumer<FundraisingViewModels>(
        builder: (BuildContext context, fundraisingViewModels, Widget? child) {
      if (fundraisingViewModels == null) {
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
                  fundraisingViewModels.slogan.toString(),
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
                        flex: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                fundraisingViewModels.communityName.toString(),
                                style: TextStyle(
                                    fontSize: 50.sp, color: Constants.primary, fontWeight: FontWeight.bold, ),
                              ),

                              fundraisingViewModels.graphicType.toString() ==
                                      GraphicTypeDropDownList.pieChart.label
                                  ? BuildPieChart(
                                      targetProgress:
                                          donationViewModels.targetProgress,
                                      fundraisingTarget:
                                          widget.fundraisingTarget ?? 0,
                                      totalDonated:
                                          donationViewModels.totalDonated)
                                  : BuildGaugeIndicator(
                                      fundraisingTarget: fundraisingViewModels
                                              .fundraiserTarget ??
                                          0,
                                      totalDonated:
                                          donationViewModels.totalDonated,
                                      targetProgress:
                                          donationViewModels.targetProgress),
                              fundraisingViewModels.getCommunitiesButton(
                                  widget.userID, widget.fundraisingID),
                              // getCommunities(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
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
                                  '-- Last Donors --',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Consumer2<DonationViewModels,
                                      FundraisingViewModels>(
                                  builder: (context, donationViewModels,
                                      fundraisingViewModels, widget) {
                                var donations = donationViewModels.donations;
                                if (donationViewModels.donations.isEmpty) {
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
                                            backgroundColor: Constants.primary,
                                            child: Text(
                                              '${donations.length - index}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              fundraisingViewModels
                                                          .showDonorNames ==
                                                      YesOrNoDropDownList
                                                          .no.label
                                                  ? getDonorNameWithHide(
                                                      donation.donorName)
                                                  : Flexible(
                                                    child: Text(donation.donorName,
                                                        style: TextStyle(
                                                            fontSize: 40.sp,
                                                            fontWeight:
                                                                FontWeight.bold), overflow: TextOverflow.ellipsis,),
                                                  ),
                                              fundraisingViewModels
                                                          .showDonorAmount ==
                                                      YesOrNoDropDownList
                                                          .yes.label
                                                  ? getDonorAmountWithDollars(
                                                      donation.donationAmount)
                                                  : getDonorAmountMaskOnAmount(
                                                      donation.donationAmount),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
/*
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
                                                '${donations.length - index}',
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
                                                    "\$${donation.donationAmount}")
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
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

  Widget getDonorNameWithHide(String donorName) {
    String? maskOnDonorName;
    List<String> parts = donorName.split(' ');
    parts.map((parts) {
      if (parts.length < 2) {
        maskOnDonorName = parts[0] + '*' * (parts.length - 1);
      } else {
        maskOnDonorName = parts[1] + '*' * (parts.length - 1);
      }
    }).join(' ');

    return Flexible(
      child: Text(
        maskOnDonorName.toString(),
        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,
      ),
    );
  }

  getDonorAmountWithDollars(double donationAmount) {
    var oCcy = NumberFormat("#,##0.00", "en_US");

    final FundraisingViewModels fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);

    if (fundraisingViewModels.currency == CurrencyDropDownList.dollar.label) {
      return Text(
        '\$ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 50.sp),
      );
    } else if (fundraisingViewModels.currency ==
        CurrencyDropDownList.euro.label) {
      return Text(
        '\€ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 50.sp),
      );
    } else if (fundraisingViewModels.currency ==
        CurrencyDropDownList.turkishLira.label) {
      return Text(
        '\₺ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 50.sp),
      );
    }
  }

  Widget getDonorAmountMaskOnAmount(double donationAmount) {
    int numberOfStar;


    if (donationAmount <= 100) {
      numberOfStar=1;
    }  else if(donationAmount > 100 && donationAmount<= 250){
      numberOfStar=2;
    }else if(donationAmount > 250 && donationAmount<= 500){
      numberOfStar=3;
    }else if(donationAmount > 500 && donationAmount<= 750){
      numberOfStar=4;
    }else if(donationAmount > 750 && donationAmount<= 1000){
      numberOfStar=5;
    }else if(donationAmount > 1000 && donationAmount<= 1500){
      numberOfStar=6;
    }else if(donationAmount > 1500 && donationAmount<= 2500){
      numberOfStar=7;
    }else if(donationAmount > 2500 && donationAmount<= 5000){
      numberOfStar=8;
    }else if(donationAmount > 5000 && donationAmount<= 7500){
      numberOfStar=9;
    }else {
      numberOfStar=10;
    }


    return Wrap(  // Wrap to prevent overflow
      spacing: 4.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: List.generate(10, (index) => (index+1) <= numberOfStar ? _buildStarIconWithColor() :_buildStarIcon() ),
    );
  }

  Widget _buildStarIcon() {
    return Icon(
      Icons.star,
       color: Colors.white,
      shadows: [Shadow(color: Colors.black, blurRadius: 10.0)],
      size: 35.sp, // Reduce size to avoid overflow
    );
  }

  _buildStarIconWithColor() {
    return Icon(
    Icons.star,
    color: Colors.yellowAccent,
    shadows: [Shadow(color: Colors.black, blurRadius: 10.0)],
    size: 35.sp, // Reduce size to avoid overflow
    );
  }
}
