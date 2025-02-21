import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/app_router.dart';
import 'package:flutter_fundraising_goal_chart/firebase_options.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:flutter_fundraising_goal_chart/views/landing_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SetupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModels()),
        ChangeNotifierProvider(create: (_) => FundraisingViewModels()),
        ChangeNotifierProvider(create: (_) => DonationViewModels()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,

    );
  }
}
