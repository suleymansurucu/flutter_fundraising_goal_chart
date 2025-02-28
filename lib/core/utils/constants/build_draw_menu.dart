import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BuildDrawMenu extends StatelessWidget {
  String? fullName;

  BuildDrawMenu({super.key});

  @override
  Widget build(BuildContext context) {
    _getFullName(context);

    return Drawer(
      backgroundColor: Constants.background,
      child: Consumer<UserViewModels>(
        builder: (context, userViewModel, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Constants.primary),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle, color: Colors.white, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        fullName != null && fullName!.isNotEmpty
                            ? 'Hello, $fullName!'
                            : 'Welcome to Fundraising App',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.black),
                title: const Text('Home'),
                onTap: () {
                  context.go(RouteNames.home);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.black),
                title: const Text('Profile'),
                onTap: () {
                  context.go(RouteNames.userProfile);
                },
              ),
              ExpansionTile(
                title: Text('Fundraising Goal Chart Tools'),
                leading: const Icon(Icons.volunteer_activism,
                    color: Colors.black),
                children: [
                  ListTile(

                    title: const Text('Create New Fundraising Display Chart',style: TextStyle(fontSize: 14),),
                    onTap: () {
                      context.go(RouteNames.fundraisingSetup);
                    },
                  ),
                  ListTile(
                    title: const Text('Previous Fundraising Display Chart',style: TextStyle(fontSize: 14),),
                    onTap: () {
                      context.go(RouteNames.allFundraisingShowList);
                    },
                  ),
                  ListTile(
                    title: const Text('Donation Enter For Fundraising',style: TextStyle(fontSize: 14),),
                    onTap: () {
                      context.go(RouteNames.entryDonation);
                    },
                  ),
                  ListTile(
                    title: const Text('List Of Donations',style: TextStyle(fontSize: 14),),
                    onTap: () {
                      context.go(RouteNames.donationList);
                    },
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.login, color: Colors.black),
                title: Text(fullName != null && fullName!.isNotEmpty
                    ? 'Go To Create Fundraising Screen'
                    : 'Sign In'),
                onTap: () {
                  Navigator.pop(context);
                  fullName != null && fullName!.isNotEmpty
                      ? context.go(RouteNames.signUp)
                      : context.go(RouteNames.singIn);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _getFullName(BuildContext context) async {
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    final _userviewModel =
        await userViewModels.getUserData(userViewModels.userModel!.userID);
    debugPrint(
        'getfullNamedeyiz biz bu userview model${userViewModels.fullName}');
    fullName = _userviewModel!.fullName;
    debugPrint('method icerisinde $fullName');
  }
}
