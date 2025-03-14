import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BuildDrawMenu extends StatefulWidget {
    const BuildDrawMenu({super.key});

  @override
  State<BuildDrawMenu> createState() => _BuildDrawMenuState();
}

class _BuildDrawMenuState extends State<BuildDrawMenu> {
  String fullName = "Guest";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Constants.background,
      child: Consumer<UserViewModels>(
        builder: (context, userViewModel, child) {

          _getFullName(context);
          debugPrint('username : $fullName');

          return Column(
            children: [
              _buildHeader(context, fullName),
              Expanded(child: _buildMenuItems(context)),
              _buildFooter(context, fullName.isNotEmpty),
              _buildCopyright(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String fullName) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade700,
            Colors.indigo.shade500,
            Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.account_circle, color: Colors.deepPurple, size: 60),
            ),
            const SizedBox(height: 15),
            Text(
              fullName.isNotEmpty ? 'Hello, $fullName!' : 'Welcome to Fundraising App',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _menuItem(Icons.home, 'Home', () => context.go(RouteNames.home)),
        _menuItem(Icons.settings, 'About Us', () => context.go(RouteNames.aboutUs)),
        _buildExpandableMenu(context),
        _menuItem(Icons.person, 'Edit Profile', () => context.go(RouteNames.userProfile)),
        _menuItem(Icons.mail, 'Contact Us', () => context.go(RouteNames.contactUs)),
      ],
    );
  }

  Widget _buildExpandableMenu(BuildContext context) {
    return ExpansionTile(
      title: const Text('Fundraising Tools', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      leading: const Icon(Icons.volunteer_activism, color: Colors.deepPurple),
      children: [
        _menuItem(Icons.add_chart, 'Create New Fundraising', () => context.go(RouteNames.fundraisingSetup)),
        _menuItem(Icons.history, 'Previous Fundraising Charts', () => context.go(RouteNames.allFundraisingShowList)),
        _menuItem(Icons.monetization_on, 'Enter Donation', () => context.go(RouteNames.entryDonation)),
        _menuItem(Icons.list, 'Donation List', () => context.go(RouteNames.donationList)),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isLoggedIn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.redAccent),
        title: Text(
          isLoggedIn ? 'Logout' : 'Sign In',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.pop(context);
          isLoggedIn ? context.go(RouteNames.home) : context.go(RouteNames.singIn);
        },
      ),
    );
  }

  Widget _buildCopyright() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Text(
          '© 2025 Fundraising App. All Rights Reserved.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void _getFullName(BuildContext context) async {
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    final _userviewModel = await userViewModels.getUserData(userViewModels.userModel!.userID);
    debugPrint(
        'getfullNamedeyiz biz bu userview model${userViewModels.fullName}');
    Future.delayed(Duration(milliseconds: 400));
    fullName = _userviewModel!.fullName!;
    debugPrint('method icerisinde $fullName');
  }
}
