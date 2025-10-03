import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8FAFC),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Kullanıcı giriş yapmışsa fundraising sayfasına yönlendir
        if (snapshot.hasData) {
          final currentUri = GoRouterState.of(context).uri.toString();
          if (!currentUri.contains(RouteNames.fundraisingSetup)) {
            context.go('${RouteNames.fundraisingSetup}$currentUri');
          }
          return const FundraisingSetupPage();
        }

        // Kullanıcı giriş yapmamışsa modern landing page göster
        return _buildLandingPage(context);
      },
    );
  }

  Widget _buildLandingPage(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildFeaturesSection(),
            _buildStatsSection(),
            _buildTestimonialsSection(),
            _buildCTASection(context),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Semantics(
              label: "Charity Progress logo - Volunteer activism icon",
              child: const Icon(
                Icons.volunteer_activism,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Semantics(
            header: true,
            child: const Text(
              "Transform Your\nFundraising Journey",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Create beautiful, real-time fundraising charts that inspire donors and track progress effortlessly. Perfect for charities, nonprofits, and community initiatives.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: "Get Started Free - Sign up for Charity Progress",
                button: true,
                child: ElevatedButton(
                  onPressed: () => context.push(RouteNames.singIn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Get Started Free",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Semantics(
                label: "Learn More - Scroll to features section",
                button: true,
                child: OutlinedButton(
                  onPressed: () => _scrollToFeatures(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Learn More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: const Text(
              "Why Choose Our Platform?",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Everything you need to create compelling fundraising campaigns",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  Icons.trending_up,
                  "Real-time Tracking",
                  "Monitor your fundraising progress with live updates and beautiful visualizations that engage your supporters.",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildFeatureCard(
                  Icons.analytics,
                  "Advanced Analytics",
                  "Get detailed insights into your donation patterns and campaign performance with comprehensive reporting.",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildFeatureCard(
                  Icons.share,
                  "Easy Sharing",
                  "Share your progress with supporters through beautiful, shareable charts and social media integration.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 40,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: const Text(
              "Trusted by Organizations Worldwide",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard("500+", "Organizations"),
              _buildStatCard("\$2M+", "Raised"),
              _buildStatCard("10K+", "Campaigns"),
              _buildStatCard("99%", "Satisfaction"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: const Text(
              "What Our Users Say",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            children: [
              Expanded(
                child: _buildTestimonialCard(
                  "Sarah Johnson",
                  "Nonprofit Director",
                  "This platform transformed how we present our fundraising progress. The real-time charts helped us increase donations by 40%!",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildTestimonialCard(
                  "Michael Chen",
                  "Community Organizer",
                  "Beautiful, easy-to-use interface that makes tracking donations simple. Our supporters love seeing the progress in real-time.",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildTestimonialCard(
                  "Emily Rodriguez",
                  "Charity Founder",
                  "The analytics and sharing features are incredible. We've been able to reach more donors and raise more funds than ever before.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(String name, String role, String testimonial) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote,
            size: 40,
            color: Color(0xFF6366F1),
          ),
          const SizedBox(height: 20),
          Text(
            testimonial,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF6366F1),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rocket_launch,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 32),
          Semantics(
            header: true,
            child: const Text(
              "Ready to Start Your Fundraising Journey?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Join thousands of organizations already using our platform to track and visualize their fundraising progress.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => context.push(RouteNames.singIn),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Get Started Free",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Charity Fundraising Goal Tracker",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Empowering organizations and individuals to visualize their fundraising progress with beautiful, real-time tracking.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  "suleymansurucu95@gmail.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _sendEmail,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "© 2025 Charity Fundraising Goal Tracker v 0.0.1. All rights reserved.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToFeatures() {
    // This would scroll to the features section
    // For now, we'll just do nothing as it's a simple implementation
  }

  void _sendEmail() async {
    const email = "suleymansurucu95@gmail.com";
    final Uri mail = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Let\'s Collaborate -from charity progress-&body=Hi Suleyman,',
    );

    if (await canLaunchUrl(mail)) {
      await launchUrl(mail);
    }
  }
}
