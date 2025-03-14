import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/change_password.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sign_up.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/user_profile.dart';
import 'package:flutter_fundraising_goal_chart/views/donation/donation_entry_page.dart';
import 'package:flutter_fundraising_goal_chart/views/donation/donation_list_page.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/all_fundraising_show_list.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/display_fundraising_chart.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/update_fundraising_page.dart';
import 'package:flutter_fundraising_goal_chart/views/home/about_us.dart';
import 'package:flutter_fundraising_goal_chart/views/home/contact_us.dart';
import 'package:flutter_fundraising_goal_chart/views/home/home_page.dart';
import 'package:flutter_fundraising_goal_chart/views/landing_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthenticated = user != null;
    final isOnAuthPage = state.matchedLocation == RouteNames.signUp ||
        state.matchedLocation == RouteNames.singIn;

    // Redirect unauthenticated users to Sign In page if they try to access protected pages
    if (!isAuthenticated &&
        (state.matchedLocation == RouteNames.fundraisingSetup ||
            state.matchedLocation == RouteNames.userProfile)) {
      return '${RouteNames.singIn}?redirect=${state.uri}';
    }

    // If user is authenticated and is on the landing page, redirect to Fundraising Setup
    if (isAuthenticated && state.matchedLocation == RouteNames.landingPage) {
      return RouteNames.fundraisingSetup;
    }

    return null; // No redirection needed, proceed as usual
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

    // ** Protected Route: Only Accessible When Signed In **
    GoRoute(
      path: RouteNames.fundraisingSetup,
      name: RouteNames.fundraisingSetup,
      builder: (context, state) => FirebaseAuth.instance.currentUser != null
          ? const FundraisingSetupPage()
          : const SingInPage(), // Redirect to Sign In if not authenticated
    ),

    GoRoute(
      path: RouteNames.userProfile,
      name: RouteNames.userProfile,
      builder: (context, state) => FirebaseAuth.instance.currentUser != null
          ? const UserProfile()
          : const SingInPage(), // Redirect to Sign In if not authenticated
    ),
    GoRoute(
      path: RouteNames.entryDonation,
      name: RouteNames.entryDonation,
      builder: (context, state) => FirebaseAuth.instance.currentUser != null
          ? const DonationEntryPage()
          : const SingInPage(),
    ),
    GoRoute(
      path: RouteNames.allFundraisingShowList,
      name: RouteNames.allFundraisingShowList,
      builder: (context, state) => FirebaseAuth.instance.currentUser != null
          ? const AllFundraisingShowList()
          : const SingInPage(),
    ),
    GoRoute(
      path: '/display-chart/:fundraisingID/:userID',
      builder: (context, state) {
        final String fundraisingID = state.pathParameters['fundraisingID']!;
        final String userID = state.pathParameters['userID']!;
        if (FirebaseAuth.instance.currentUser != null) {
          return DisplayFundraisingChart(
            fundraisingID: fundraisingID,
            userID: userID,
          );
        } else {
          return const SingInPage();
        }
      },
    ),
    GoRoute(
      path: RouteNames.donationList,
      name: RouteNames.donationList,
      builder: (context, state) => FirebaseAuth.instance.currentUser != null
          ? const DonationListPage()
          : const SingInPage(),
    ),
    GoRoute(
      path: '/update-display-chart/:fundraisingID/:userID',
      builder: (context, state) {
        final String fundraisingID = state.pathParameters['fundraisingID']!;
        final String userID = state.pathParameters['userID']!;
        if (FirebaseAuth.instance.currentUser != null) {
          return UpdateFundraisingPage(
            fundraisingID: fundraisingID,
            userID: userID,
          );
        } else {
          return const SingInPage();
        }
      },
    ),
    GoRoute(
      path: RouteNames.changePassword,
      name: RouteNames.changePassword,
      builder: (context, state) => FirebaseAuth.instance.currentUser != null
          ? const ChangePassword()
          : SingInPage(),
    ),

    GoRoute(
      path: RouteNames.home,
      name: RouteNames.home,
      builder: (context, state) => HomePage(),
    ),

    GoRoute(
      path: RouteNames.aboutUs,
      name: RouteNames.aboutUs,
      builder: (context, state) => AboutUs(),
    ),
    GoRoute(
      path: RouteNames.contactUs,
      name: RouteNames.contactUs,
      builder: (context, state) => ContactUs(),
    ),
  ],
);
