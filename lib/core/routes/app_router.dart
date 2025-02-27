import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sign_up.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/user_profile.dart';
import 'package:flutter_fundraising_goal_chart/views/donation/donation_entry_page.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/all_fundraising_show_list.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/display_fundraising_chart.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:flutter_fundraising_goal_chart/views/home/home_page.dart';
import 'package:flutter_fundraising_goal_chart/views/landing_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
//  initialLocation: RouteNames.landingPage,
  redirect: (context, state)  {
    final user = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration(milliseconds: 500));
    final isAuthenticated = user != null;
    final isOnAuthPage = state.matchedLocation == RouteNames.signUp || state.matchedLocation == RouteNames.singIn;

    debugPrint('User authenticated: $isAuthenticated');
    debugPrint('Current URL: ${state.matchedLocation}');

    if (!isAuthenticated && !isOnAuthPage) {
      debugPrint('Redirecting to Sign In');
      return '${RouteNames.singIn}?redirect=${state.uri}';
    }

    if (isAuthenticated && state.matchedLocation == RouteNames.landingPage) {
      debugPrint('Redirecting to Fundraising Setup');
      return RouteNames.fundraisingSetup;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: RouteNames.landingPage,
      name: RouteNames.landingPage,
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: RouteNames.signUp,
      name: RouteNames.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: RouteNames.singIn,
      name: RouteNames.singIn,
      builder: (context, state) => const SingInPage(),
    ),
    GoRoute(
      path: RouteNames.fundraisingSetup,
      name: RouteNames.fundraisingSetup,
      builder: (context, state) => const FundraisingSetupPage(),
    ),
    GoRoute(
      path: RouteNames.home,
      name: RouteNames.home,
      builder: (context, state) =>  HomePage(),
    ),
    GoRoute(
      path: RouteNames.entryDonation,
      name: RouteNames.entryDonation,
      builder: (context, state) => const DonationEntryPage(),
    ),
    GoRoute(
      path: RouteNames.userProfile,
      name: RouteNames.userProfile,
      builder: (context, state) => const UserProfile(),
    ),
    GoRoute(
      path: RouteNames.allFundraisingShowList,
      name: RouteNames.allFundraisingShowList,
      builder: (context, state) => const AllFundraisingShowList(),
    ),
    GoRoute(
      path: '/display-chart/:fundraisingID/:userID',
      builder: (context, state) {
        final String fundraisingID = state.pathParameters['fundraisingID']!;
        final String userID = state.pathParameters['userID']!;
        return DisplayFundraisingChart(
          fundraisingID: fundraisingID,
          userID: userID,
        );
      },
    ),
  ],
);
