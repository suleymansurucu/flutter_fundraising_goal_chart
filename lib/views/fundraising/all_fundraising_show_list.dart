import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllFundraisingShowList extends StatefulWidget {
  const AllFundraisingShowList({super.key});

  @override
  State<AllFundraisingShowList> createState() => _AllFundraisingShowListState();
}

class _AllFundraisingShowListState extends State<AllFundraisingShowList> {
  final GlobalKey<ScaffoldState> _scafoldFundraisingShowList =
      GlobalKey<ScaffoldState>();
  late Future<List<FundraisingModel>> _future;
  late final String userID;

  @override
  void initState() {
    super.initState();
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    userID = userViewModels.userModel!.userID ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userID.isEmpty) {
        context.go(RouteNames.singIn);
      }
    });

    _future = getFundraisingData(userID);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scafoldFundraisingShowList,
      appBar: CustomAppBar(
        title: 'Your Fundraising List',
        scaffoldKey: _scafoldFundraisingShowList,
      ),
      drawer: BuildDrawMenu(),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 2500.w,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Fundraising Display Chart Lists',
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
                Expanded(
                  child: FutureBuilder<List<FundraisingModel>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error loading data!'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No fundraising campaigns found.'));
                      }
                      final fundraisingList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        // primary: false,
                        itemCount: fundraisingList.length,
                        itemBuilder: (context, index) {
                          final fundraiser = fundraisingList[index];
                          final screenWidth = MediaQuery.of(context).size.width;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Constants.accent,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                title: screenWidth > 750
                                    ? _rowTitle(fundraiser)
                                    : _columnTitle(fundraiser),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<FundraisingModel>> getFundraisingData(String userID) async {
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    final fundraisingList =
        await fundraisingViewModels.fetchFundraising(userID);
    return fundraisingList ?? [];
  }

  void _deleteFundraising(String userID, String fundraisingID) {
    FundraisingViewModels fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    fundraisingViewModels.userRepository
        .deleteFundraising(userID, fundraisingID);
  }

  _rowTitle(FundraisingModel fundraiser) {
    return Row(
      children: [
        Expanded(
          child: Text(
            fundraiser.uniqueName,
            style: TextStyle(
              fontSize: 40.w,
              fontWeight: FontWeight.w500,
              color: Constants.textColor,
            ),
          ),
        ),
        Spacer(),
        BuildElevatedButton(
          onPressed: () {
            final fundraisingID = fundraiser.fundraisingID;
            context.go('/display-chart/$fundraisingID/$userID');
          },
          buttonText: 'Go to Display Chart Page',
          buttonColor: Constants.primary,
          textColor: Colors.white,
          paddingHorizontal: 20,
          buttonFontSize: 30.w,
        ),
        SizedBox(width: 5),
        BuildElevatedButton(
          onPressed: () {
            final fundraisingID = fundraiser.fundraisingID;
            context.go('/update-display-chart/$fundraisingID/$userID');
          },
          buttonText: 'Update',
          buttonColor: Colors.green,
          textColor: Colors.white,
          paddingHorizontal: 20,
          buttonFontSize: 30.w,
        ),
        SizedBox(width: 5),
        BuildElevatedButton(
          buttonFontSize: 30.w,
          paddingHorizontal: 20,
          onPressed: () {
            final fundraisingID = fundraiser.fundraisingID;
            showDialog(
                context: context,
                builder: (BuildContext buildcontext) => AlertDialog(
                      title: const Text(
                          'Are You Sure For Delete Fundraising Chart Page'),
                      content:
                          Text('You are deleting => ${fundraiser.uniqueName}'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteFundraising(userID, fundraisingID!);
                            _future = getFundraisingData(userID);
                            setState(() {});
                            Navigator.pop(context);
                            context.go(RouteNames.allFundraisingShowList);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
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
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _columnTitle(FundraisingModel fundraiser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Daha iyi hizalama
      children: [
        SizedBox(
          width: double.infinity, // Genişliği belirle
          child: Text(
            fundraiser.uniqueName,
            style: TextStyle(
              fontSize: 40.w,
              fontWeight: FontWeight.w500,
              color: Constants.textColor,
            ),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 5, // Butonlar arasında boşluk bırakır
          runSpacing: 5, // Yeni satıra geçtiğinde boşluk bırakır
          children: [
            BuildElevatedButton(
              onPressed: () {
                final fundraisingID = fundraiser.fundraisingID;
                context.go('/display-chart/$fundraisingID/$userID');
              },
              buttonText: 'Go to Display Chart Page',
              buttonColor: Constants.primary,
              textColor: Colors.white,
              paddingHorizontal: 20,
              buttonFontSize: 30.w,
            ),
            BuildElevatedButton(
              onPressed: () {
                final fundraisingID = fundraiser.fundraisingID;
                context.go('/update-display-chart/$fundraisingID/$userID');
              },
              buttonText: 'Update',
              buttonColor: Colors.green,
              textColor: Colors.white,
              paddingHorizontal: 20,
              buttonFontSize: 30.w,
            ),
            BuildElevatedButton(
              buttonFontSize: 30.w,
              paddingHorizontal: 20,
              onPressed: () {
                final fundraisingID = fundraiser.fundraisingID;
                showDialog(
                    context: context,
                    builder: (BuildContext buildcontext) => AlertDialog(
                      title: const Text(
                          'Are You Sure For Delete Fundraising Chart Page'),
                      content:
                      Text('You are deleting => ${fundraiser.uniqueName}'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteFundraising(userID, fundraisingID!);
                            _future = getFundraisingData(userID);
                            setState(() {});
                            Navigator.pop(context);
                            context.go(RouteNames.allFundraisingShowList);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
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
              textColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}
