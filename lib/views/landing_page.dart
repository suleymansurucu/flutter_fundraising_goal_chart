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
        }

        // Kullanıcı giriş yapmışsa fundraising sayfasına yönlendir
        if (snapshot.hasData) {
          final currentUri = GoRouterState.of(context).uri.toString(); // Mevcut URL'yi al
          if (!currentUri.contains(RouteNames.fundraisingSetup)) {
            context.go('${RouteNames.fundraisingSetup}$currentUri'); // Parametreleri koruyarak yönlendir
          }
          return const FundraisingSetupPage();
        }

        // Kullanıcı giriş yapmamışsa giriş sayfasına yönlendir
        else {
          final currentUri = GoRouterState.of(context).uri.toString(); // Mevcut URL'yi al
          if (!currentUri.contains(RouteNames.singIn)) {
            context.go('${RouteNames.singIn}?redirect=$currentUri'); // Kullanıcı giriş yapınca geri dönmesini sağla
          }
          return const SingInPage();
        }
      },
    );
  }}
