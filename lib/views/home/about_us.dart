import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});

  final GlobalKey<ScaffoldState> _scaffoldAboutUs = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAboutUs,
      appBar: CustomAppBar(
        title: 'About Us',
        scaffoldKey: _scaffoldAboutUs,
      ),
      drawer: BuildDrawMenu(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 850, // Max width for better layout on larger screens
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
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
              children: [
                const Text(
                  "Welcome to Charity Fundraising Goal Tracker",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Hi, I'm Suleyman. I have voluntarily developed this platform to help non-profit organizations and individuals manage their fundraising processes more efficiently and transparently. My goal is to simplify fundraising efforts and enable organizations to present their progress clearly to their members and supporters.\n\n"
                      "That’s why I have made Charity Fundraising Goal Tracker – Real-Time Progress Visualization completely free for everyone. You can access all features simply by signing up with your email address.",
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 30),

                _buildSection("🚀 Our Mission",
                    "At Charity Fundraising Goal Tracker – Real-Time Progress Visualization, our mission is to provide an intuitive and user-friendly platform that empowers individuals, communities, and organizations to raise funds for causes they care about."),

                _buildHighlightedSection("💡 What We Offer", [
                  "Visual Fundraising Progress: Track and showcase your fundraising progress with interactive charts.",
                  "Secure Donations: Ensure safe and reliable transactions for both donors and fundraisers. You can choose to hide donor names or donation amounts if needed.",
                  "Community Engagement: Stay connected with your supporters and share key updates about your campaign. Track multiple communities on a single graph.",
                  "Flexible Campaign Management: Set goals, manage your fundraising progress, and adjust strategies whenever necessary."
                ]),

                _buildSection(
                  "🤝 Join Us",
                  "Whether you are raising funds for a personal cause, a non-profit organization, or a community initiative, Charity Fundraising Goal Tracker – Real-Time Progress Visualization is here to support you at every step!\n\n"
                      " Start your fundraising campaign today and make a difference! ",
                ),

                const SizedBox(height: 25),
                _buildContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.6), // Improve readability
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, height: 1.6),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📧 Contact Us",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Open email client (future implementation)
          },
          child: const Text(
            "suleymansurucu95@gmail.com",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
