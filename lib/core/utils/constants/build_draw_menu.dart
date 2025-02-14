import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/user_profile.dart';
import 'package:flutter_fundraising_goal_chart/views/donation/donation_entry_page.dart';
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.black),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserProfile()));                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.volunteer_activism, color: Colors.black),
                title: const Text('Fundraising'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserProfile()));
                },
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
                      ? MaterialPageRoute(
                          builder: (context) => DonationEntryPage())
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SingInPage()));
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
