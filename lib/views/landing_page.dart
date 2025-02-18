import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          context.go(RouteNames.fundraisingSetup);
          return const FundraisingSetupPage();
        } else {
          context.go(RouteNames.singIn);
          return const SingInPage();
        }
      },
    );
  }
}
