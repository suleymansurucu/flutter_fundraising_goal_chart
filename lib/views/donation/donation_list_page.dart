import 'dart:io';
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
import 'package:path_provider/path_provider.dart';
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
                          'Select a Fundraising Event',
                          style: TextStyle(
                            color: Constants.textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Constants.background,
                                    value:
                                        fundraisingViewModels.thisFundraising,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        fundraisingViewModels
                                            .onFundraising(newValue);

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
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Constants.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              'Donor List',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Ortada hizalama
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //   exportExcel();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              alignment: Alignment.centerRight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.download,
                                  color: Constants.primary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Export Text',
                                  style: TextStyle(color: Constants.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer2<DonationViewModels, FundraisingViewModels>(builder:
                (context, donationViewModels, fundraisingViewModels, widget) {
              var donations = donationViewModels.donations;
              if (donationViewModels.donations.isEmpty || donations == null) {
                return Center(child: Text("No donations yet."));
              }
              return SizedBox(
                height: 800.h,
                width: 600,
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
                        title: Text(
                          donation.donorName,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle:
                            getDonorAmountWithDollars(donation.donationAmount),
                        trailing: BuildElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext buildcontext) =>
                                      AlertDialog(
                                        title: const Text(
                                            'Are You Sure For Delete Donation'),
                                        content: Text(
                                            'You are deleting donor is ${donation.donorName}, amount is \$ ${donation.donationAmount}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _deleteDonation(donation);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                        // icon: Icon(Icons.delete, color: Constants.highlight,),
                                        backgroundColor: Constants.background,
                                        elevation: 10,
                                        // titleTextStyle: TextStyle(color: Constants.primary),
                                      ));
                            },
                            buttonText: 'Delete',
                            buttonColor: Colors.redAccent,
                            textColor: Colors.white),
                      ),
                    );
                  },
                ),
              );
            }),
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

    fundraisingModel = await fundraisingViewModels.getFundraiser(
        userID, fundraisingViewModels.fundraisingID!);
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
    if (donationAmount == null) {
      return Text('N/A');
    }
    var oCcy = NumberFormat("#,##0.00", "en_US");

    var currency = fundraisingModel!.currency;

    if (currency == CurrencyDropDownList.dollar.label) {
      return Text(
        '\$ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 20),
      );
    } else if (currency == CurrencyDropDownList.euro.label) {
      return Text(
        '\€ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 20),
      );
    } else if (currency == CurrencyDropDownList.turkishLira.label) {
      return Text(
        '\₺ ${oCcy.format(donationAmount)}',
        style: TextStyle(fontSize: 20),
      );
    }
  }

  void _getDonations() async {
    final donationViewModel =
        Provider.of<DonationViewModels>(context, listen: false);
    final FundraisingViewModels fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    try {
      fundraisingModel = await fundraisingViewModels.getFundraiser(
          userID, fundraisingViewModels.fundraisingID!);

      donationViewModel.listenToDonations(
          userID,
          fundraisingViewModels.fundraisingID!,
          fundraisingViewModels.thisFundraising!,
          1);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading donations: $e')),
      );
    }
  }

  void _deleteDonation(DonationModel donationModel) {
    DonationViewModels donationViewModels =
        Provider.of<DonationViewModels>(context, listen: false);

    var deletedDonationModel = donationModel;
    donationViewModels.deleteDonation(deletedDonationModel);
  }
}
/*
    Future<void> exportExcel() async {
    DonationViewModels donationViewModels =
    Provider.of<DonationViewModels>(context, listen: false);
    var donationList = donationViewModels.donations;

    if (donationList.isEmpty || donationList == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No donations available to export.")),
      );
      return;
    }

    var excel = exc.Excel.createExcel();
    exc.Sheet sheet = excel[donationList[0].communityName];

    // Ensure correct type usage by wrapping each string in TextCellValue
    sheet.appendRow([
      exc.TextCellValue('index'),
      exc.TextCellValue('Donor Name'),
      exc.TextCellValue('Donor Amount')
    ]);

    int index = 1; // Initialize index before loop
    for (var donations in donationList) {
      // Ensure the values being added to the row are of type TextCellValue
      var row = [
        exc.TextCellValue(index.toString()), // Ensure 'index' is wrapped in TextCellValue
        exc.TextCellValue(donations.donorName), // Ensure donorName is wrapped in TextCellValue
        exc.TextCellValue(donations.donationAmount.toString()) // Ensure donationAmount is wrapped in TextCellValue
      ];
      sheet.appendRow(row); // Add the row to the sheet
      index++; // Increment the index after adding the row
    }

    // Save the file to device storage
    // Encode the excel file
    // Check if running on the web and handle accordingly
    if (kIsWeb) {
      var bytes = await excel.encode()!;
      final blob = html.Blob([Uint8List.fromList(bytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element for downloading
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'donations.xlsx'
        ..click();

      // Clean up the URL object after download
      html.Url.revokeObjectUrl(url);

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Donations exported to Excel.")),
      );
    } else {
      // Handle export for non-web environments (e.g., mobile)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/donations.xlsx');
      await file.writeAsBytes(await excel.encode()!);

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Donations exported to Excel.")),
      );
  }
}


   */
