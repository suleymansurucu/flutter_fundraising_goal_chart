import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sign_up.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/user_profile.dart';
import 'package:flutter_fundraising_goal_chart/views/donation/donation_entry_page.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:flutter_fundraising_goal_chart/views/home/home_page.dart';
import 'package:flutter_fundraising_goal_chart/views/landing_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/landing-page', routes: [
  GoRoute(
    path: RouteNames.landingPage,
    name: RouteNames.landingPage,
    builder: (context, state) => LandingPage(),
  ),
  GoRoute(
    path: RouteNames.signUp,
    name: RouteNames.signUp,
    builder: (context, state) => SignUpPage(),
  ),
  GoRoute(
    path: RouteNames.singIn,
    name: RouteNames.singIn,
    builder: (context, state) => SingInPage(),
  ),
  GoRoute(
    path: RouteNames.fundraisingSetup,
    name: RouteNames.fundraisingSetup,
    builder: (context, state) => FundraisingSetupPage(),
  ),
  GoRoute(
    path: RouteNames.home,
    name: RouteNames.home,
    builder: (context, state) => HomePage(),
  ),
  GoRoute(
    path: RouteNames.entryDonation,
    name: RouteNames.entryDonation,
    builder: (context, state) => DonationEntryPage(),
  ),
  GoRoute(
    path: RouteNames.userProfile,
    name: RouteNames.userProfile,
    builder: (context, state) => UserProfile(),
  ),
]);
