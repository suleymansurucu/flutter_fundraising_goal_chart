import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllFundraisingShowList extends StatefulWidget {
  const AllFundraisingShowList({super.key});

  @override
  State<AllFundraisingShowList> createState() => _AllFundraisingShowListState();
}

class _AllFundraisingShowListState extends State<AllFundraisingShowList> {
  final GlobalKey<ScaffoldState> globalKeyForAllFundraisingShow = GlobalKey<ScaffoldState>();
  late Future<List<FundraisingModel>> _future;
  late final String userID;

  @override
  void initState() {
    super.initState();
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    userID = userViewModels.userModel!.userID;
    _future = getFundraisingData(userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKeyForAllFundraisingShow,
      appBar: CustomAppBar(
        title: 'Your Fundraiser List',
        scaffoldKey: globalKeyForAllFundraisingShow,
      ),
      body: FutureBuilder<List<FundraisingModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No fundraising campaigns found.'));
          }
          final fundraisingList = snapshot.data!;
          return ListView.builder(
            itemCount: fundraisingList.length,
            itemBuilder: (context, index) {
              final fundraiser = fundraisingList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Text((index + 1).toString()),
                    title: Text(fundraiser.uniqueName),
                    subtitle: BuildElevatedButton(
                      onPressed: () {
                        final fundraisingID = fundraiser.fundraisingID;
                        context.go('/display-chart/$fundraisingID/$userID');
                      },
                      buttonText: 'Click to Display Goal Chart',
                      buttonColor: Constants.accent,
                      textColor: Constants.textColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<FundraisingModel>> getFundraisingData(String userID) async {
    final fundraisingViewModels = Provider.of<FundraisingViewModels>(context, listen: false);
    final fundraisingList = await fundraisingViewModels.fetchFundraising(userID);
    return fundraisingList ?? [];
  }
}
