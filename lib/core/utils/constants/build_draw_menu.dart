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
          // Only call _getFullName if we don't have the name yet
          if (userViewModel.userModel != null && fullName == "Guest") {
            _getFullName(context);
          }

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFA855F7),
          ],
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.volunteer_activism,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fullName.isNotEmpty ? 'Hello, $fullName!' : 'Welcome!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              fullName.isNotEmpty ? 'Ready to track your progress?' : 'Sign in to get started',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Consumer<UserViewModels>(
      builder: (context, userViewModel, child) {
        final isAuthenticated = userViewModel.userModel != null;
        
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            _menuItem(Icons.home, 'Home', () => context.go(RouteNames.home)),
            _menuItem(Icons.info_outline, 'About Us', () => context.go(RouteNames.aboutUs)),
            if (isAuthenticated) ...[
              _buildExpandableMenu(context),
              _menuItem(Icons.person, 'Edit Profile', () => context.go(RouteNames.userProfile)),
            ],
            _menuItem(Icons.mail, 'Contact Us', () => context.go(RouteNames.contactUs)),
          ],
        );
      },
    );
  }

  Widget _buildExpandableMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: const Text(
          'Fundraising Tools',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.volunteer_activism,
            color: Color(0xFF6366F1),
            size: 20,
          ),
        ),
        children: [
          _menuItem(Icons.add_chart, 'Create New Fundraising', () => context.go(RouteNames.fundraisingSetup)),
          _menuItem(Icons.history, 'My Fundraising Charts', () => context.go(RouteNames.allFundraisingShowList)),
          _menuItem(Icons.monetization_on, 'Enter Donation', () => context.go(RouteNames.entryDonation)),
          _menuItem(Icons.list, 'Donation List', () => context.go(RouteNames.donationList)),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isLoggedIn) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isLoggedIn 
            ? Colors.red.withOpacity(0.05)
            : const Color(0xFF10B981).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLoggedIn 
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFF10B981).withOpacity(0.1),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLoggedIn 
                ? Colors.red.withOpacity(0.1)
                : const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isLoggedIn ? Icons.logout : Icons.login,
            color: isLoggedIn ? Colors.red : const Color(0xFF10B981),
            size: 18,
          ),
        ),
        title: Text(
          isLoggedIn ? 'Logout' : 'Sign In',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLoggedIn ? Colors.red : const Color(0xFF10B981),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (isLoggedIn) {
            // Handle logout
            final userViewModel = Provider.of<UserViewModels>(context, listen: false);
            userViewModel.signOutWithEmailAndPassword(userViewModel.userModel!.userID);
            context.go(RouteNames.home);
          } else {
            context.go(RouteNames.singIn);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Text(
          '© 2025 Charity Fundraising Goal Tracker v 0.0.1.', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6366F1),
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: const Color(0xFF6366F1).withOpacity(0.05),
      ),
    );
  }

  void _getFullName(BuildContext context) async {
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    if (userViewModels.userModel != null && userViewModels.fullName == null) {
      final _userviewModel = await userViewModels.getUserData(userViewModels.userModel!.userID);
      if (_userviewModel?.fullName != null) {
        fullName = _userviewModel!.fullName!;
        setState(() {}); // Update UI only when we have the name
      }
    } else if (userViewModels.fullName != null) {
      fullName = userViewModels.fullName!;
    }
  }
}
