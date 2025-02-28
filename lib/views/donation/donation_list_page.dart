import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_drop_down_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DonationListPage extends StatefulWidget {
  const DonationListPage({super.key});

  @override
  State<DonationListPage> createState() => _DonationListPageState();
}

class _DonationListPageState extends State<DonationListPage> {
  List<String> list = [];
  String? thisFundraising;
  String? FundraisingID;
  FundraisingModel? fundraisingModel;
  late final String userID;
  final _scafoldKeyForDonationListPage = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldDonationListKey =
      GlobalKey<ScaffoldState>();

  final _formKeyFetchDonationList = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataFromViewModes();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldDonationListKey,
      appBar: CustomAppBar(
        title: 'List Of Donations',
        scaffoldKey: _scaffoldDonationListKey,
      ),
      drawer: BuildDrawMenu(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background2.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/donations.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Consumer2<DonationViewModels, FundraisingViewModels>(
                builder: (context, donationViewModels, fundraisingViewModels,
                    widget) {
                  return Form(
                    key: _formKeyFetchDonationList,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Select a Fundraising Event:',
                          style: TextStyle(
                            color: Constants.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Divider(),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants.primary, width: 1.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Constants.background,
                                    value:
                                    fundraisingViewModels.thisFundraising,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        fundraisingViewModels.onFundraising(newValue);
                                        debugPrint('Selected Community: ${fundraisingViewModels.thisFundraising}');

                                        // _onFundraising(newValue);
                                      }
                                    },
                                    isExpanded: true,
                                    items: list.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            BuildElevatedButton(
                                onPressed: () {
                                  _getDonations();
                                },
                                buttonText: 'Show Donations',
                                buttonColor: Constants.accent,
                                textColor: Colors.white),
                          ],
                        ),

                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  Consumer2<DonationViewModels, FundraisingViewModels>(
                      builder: (context, donationViewModels,
                          fundraisingViewModels, widget) {
                    var donations = donationViewModels.donations;
                    if (donationViewModels.donations.isEmpty || donations == null) {
                      return Center(child: Text("No donations yet."));
                    }
                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(8),
                        itemCount: donations.length,
                        itemBuilder: (context, index) {
                          final DonationModel donation = donations[index];
                          return Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                                  Flexible(
                                    child: Text(
                                      donation.donorName,
                                      style: TextStyle(
                                          fontSize: 40.sp,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  BuildElevatedButton(onPressed: (){}, buttonText: 'Delete', buttonColor: Colors.redAccent, textColor: Colors.white)
                                ],
                              ),
                              subtitle: getDonorAmountWithDollars(
                                  donation.donationAmount)
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchDataFromViewModes() async {
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);

    await fundraisingViewModels.fetchData();
    Future.delayed(Duration(milliseconds: 400));
    FundraisingID = fundraisingViewModels.fundraisingID;
    thisFundraising = fundraisingViewModels.thisFundraising;
    list = fundraisingViewModels.list!;
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    userID = userViewModels.userModel!.userID;


    /*final donationViewModel =
    Provider.of<DonationViewModels>(context, listen: false);
    donationViewModel.listenToDonations(
        userID,
        FundraisingID!,
        thisFundraising!,
        fundraisingViewModels.communityCount?.toInt() ?? 1);*/

     fundraisingModel=await fundraisingViewModels.getFundraiser(userID, fundraisingViewModels.fundraisingID!);
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300), // Yumuşak kaydırma
        curve: Curves.easeOut,
      );
    }
  }

  getDonorAmountWithDollars(var donationAmount) {
    debugPrint('donation Amount : $donationAmount');
    if (donationAmount == null) {
      return Text('N/A');
    }
    var oCcy = NumberFormat("#,##0.00", "en_US");



    var currency=fundraisingModel!.currency;
    debugPrint('currency : ${currency}');

    if (currency == CurrencyDropDownList.dollar.label) {
      return Text(
        '\$ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 50.sp),
      );
    } else if (currency == CurrencyDropDownList.euro.label) {
      return Text(
        '\€ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 50.sp),
      );
    } else if (currency == CurrencyDropDownList.turkishLira.label) {
      return Text(
        '\₺ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 50.sp),
      );
    }


  }

  void _getDonations() {
    final donationViewModel =
        Provider.of<DonationViewModels>(context, listen: false);
    final FundraisingViewModels fundraisingViewModels =
    Provider.of<FundraisingViewModels>(context, listen: false);
    try {
      donationViewModel.listenToDonations(
          userID, fundraisingViewModels.fundraisingID!, fundraisingViewModels.thisFundraising!, 1);

      debugPrint('community name mi ne acaba ? $thisFundraising');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading donations: $e')),
      );
    }
  }
}
