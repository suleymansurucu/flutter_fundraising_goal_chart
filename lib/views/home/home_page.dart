import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldHomePage = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldHomePage,
      appBar: CustomAppBar(
        title: 'Charity Fundraising Goal Tracker',
        scaffoldKey: _scaffoldHomePage,
      ),
      drawer: BuildDrawMenu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIntroSection(context),
            const SizedBox(height: 30),
            _buildVideoSection(),
            const SizedBox(height: 30),
            _buildSignInCTA(context),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        width: 900, // Slightly wider for better readability
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 3,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Charity Fundraising Goal Tracker",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Charity Fundraising Goal Tracker helps individuals and organizations visualize their fundraising progress in real-time. Whether for personal causes, non-profits, or community initiatives, this platform makes presenting and tracking donations simple and effective.",
              style: TextStyle(fontSize: 17, height: 1.6, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "To start using Charity Fundraising Goal Tracker, simply sign in!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            "How to Create & Track Your Fundraising Chart - Step-by-Step Guide",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Container(
            width: 780,
            // height: 430, // Slightly taller for a better viewing experience
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: HtmlWidget(
                '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/Jo5p091lzho?si=bsPsSkDEPrf1fSeH" frameborder="0" allowfullscreen></iframe>',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 900,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "Start Using Charity Fundraising Goal Tracker",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Track your donations in real-time and present them visually. Simply sign in to get started!",
              style: TextStyle(fontSize: 17, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push(RouteNames.singIn);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sign In Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      color: Colors.deepPurple.shade800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Charity Fundraising Goal Tracker",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Empowering organizations and individuals to visualize their fundraising progress.",
            style: TextStyle(fontSize: 15, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              _sendEmail();
            },
            icon: const Icon(Icons.send),
            label: const Text(
              "📧 suleymansurucu95@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "© 2025 Charity Fundraising Goal Tracker v 0.0.1. All rights reserved.",
            style: TextStyle(fontSize: 13, color: Colors.white54),
          ),
        ],
      ),
    );
  }
  void _sendEmail() async{
    const email = "suleymansurucu95@gmail.com";
    final Uri mail = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Let\'s Collaborate -from charity progress-&body=Hi Suleyman,',
    );

    if (await canLaunchUrl(mail)) {
      await launchUrl(mail);
    } else {

    }
  }
}
