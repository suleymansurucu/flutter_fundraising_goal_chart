import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactUs extends StatelessWidget {
  ContactUs({super.key});

  final GlobalKey<ScaffoldState> _scaffoldContactUs = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldContactUs,
      appBar: CustomAppBar(
        title: 'Contact Me',
        scaffoldKey: _scaffoldContactUs,
      ),
      drawer: BuildDrawMenu(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 600, // Set max width for better layout
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Let's Build Something Together!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  "If you have a project idea, a question, or would like to collaborate on something exciting, feel free to reach out!\n\n"
                      "Just send me an email, and let's discuss how we can create something great together!",
                  style: TextStyle(fontSize: 16, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    _sendEmail();
                  },
                  icon: const Icon(Icons.send),
                  label: const Text(
                    "Send Me an Email",
                    style: TextStyle(fontSize: 18),
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
                const SizedBox(height: 15),
                const Text(
                  "📧 suleymansurucu95@gmail.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
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
    print("🚨 Mail client açılamadı!");
    }
  }
}
