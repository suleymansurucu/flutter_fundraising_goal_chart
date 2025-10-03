import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldHomePage = GlobalKey<ScaffoldState>();
  late AnimationController _heroAnimationController;
  late AnimationController _featuresAnimationController;
  late AnimationController _videoAnimationController;
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _featuresFadeAnimation;
  late Animation<double> _videoFadeAnimation;
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _featuresAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _videoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroAnimationController, curve: Curves.easeInOut),
    );
    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroAnimationController, curve: Curves.easeOutCubic));

    _featuresFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _featuresAnimationController, curve: Curves.easeInOut),
    );
    _videoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _videoAnimationController, curve: Curves.easeInOut),
    );

    // Initialize video player
    _initializeVideo();

    _heroAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _featuresAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _videoAnimationController.forward();
    });
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/fundraising.mp4');
    await _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.setVolume(0.0); // Mute the video
    if (mounted) {
      setState(() {
        _isVideoInitialized = true;
      });
      _videoController.play();
    }
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _featuresAnimationController.dispose();
    _videoAnimationController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldHomePage,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Charity Fundraising Goal Tracker',
        scaffoldKey: _scaffoldHomePage,
      ),
      drawer: const BuildDrawMenu(),
      body: Consumer<UserViewModels>(
        builder: (context, userViewModel, child) {
          final isAuthenticated = userViewModel.userModel != null;
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeroSection(context, isAuthenticated),
                const SizedBox(height: 80),
                _buildFeaturesSection(),
                const SizedBox(height: 80),
                _buildVideoSection(),
                const SizedBox(height: 80),
                if (!isAuthenticated) _buildSignInCTA(context),
                const SizedBox(height: 80),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isAuthenticated) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFA855F7),
            Color(0xFFEC4899),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Enhanced animated background elements
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _heroAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _heroAnimationController.value * 2 * math.pi,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: AnimatedBuilder(
              animation: _heroAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -_heroAnimationController.value * math.pi,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                    ),
                  ),
                );
              },
            ),
          ),
          // Floating particles
          ...List.generate(8, (index) {
            return Positioned(
              top: 50 + (index * 80),
              left: 20 + (index * 50),
              child: AnimatedBuilder(
                animation: _heroAnimationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      math.sin(_heroAnimationController.value * 2 * math.pi + index) * 20,
                      math.cos(_heroAnimationController.value * 2 * math.pi + index) * 10,
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          // Main content with improved layout
          Center(
            child: FadeTransition(
              opacity: _heroFadeAnimation,
              child: SlideTransition(
                position: _heroSlideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 1200) {
                        // Desktop layout with video on the right
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left side - Text content
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Enhanced animated icon with glow effect
                                  AnimatedBuilder(
                                    animation: _heroAnimationController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: 0.8 + (_heroAnimationController.value * 0.2),
                                        child: Container(
                                          padding: const EdgeInsets.all(32),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.3),
                                                spreadRadius: 0,
                                                blurRadius: 30,
                                                offset: const Offset(0, 15),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFF6366F1).withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 40,
                                                offset: const Offset(0, 20),
                                              ),
                                            ],
                                          ),
                                          child: Semantics(
                                            label: "Charity Progress logo - Volunteer activism icon",
                                            child: const Icon(
                                              Icons.volunteer_activism,
                                              size: 70,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 50),
                                  // Enhanced title with better typography
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Colors.white, Colors.white70, Colors.white60],
                                    ).createShader(bounds),
                                    child: Semantics(
                                      header: true,
                                      child: const Text(
                                        "Charity Fundraising\nGoal Tracker",
                                        style: TextStyle(
                                          fontSize: 56,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          height: 1.1,
                                          letterSpacing: -2,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 4),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Enhanced subtitle
                                  Container(
                                    constraints: const BoxConstraints(maxWidth: 700),
                                    child: const Text(
                                      "Transform your fundraising efforts with beautiful, real-time progress tracking. Perfect for charities, nonprofits, and community initiatives that want to make a real impact.",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white70,
                                        height: 1.7,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  // Enhanced CTA Button
                                  if (!isAuthenticated)
                                    AnimatedBuilder(
                                      animation: _heroAnimationController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(0, 30 * (1 - _heroAnimationController.value)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(0.4),
                                                  spreadRadius: 0,
                                                  blurRadius: 30,
                                                  offset: const Offset(0, 15),
                                                ),
                                                BoxShadow(
                                                  color: const Color(0xFF6366F1).withOpacity(0.3),
                                                  spreadRadius: 0,
                                                  blurRadius: 40,
                                                  offset: const Offset(0, 20),
                                                ),
                                              ],
                                            ),
                                            child: Semantics(
                                              label: "Get Started Free - Sign up for Charity Progress",
                                              button: true,
                                              child: ElevatedButton(
                                                onPressed: () => context.push(RouteNames.singIn),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: const Color(0xFF6366F1),
                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                child: const Text(
                                                  "Get Started Free",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 60),
                            // Right side - Video player
                            Expanded(
                              flex: 2,
                              child: _buildVideoPlayer(),
                            ),
                          ],
                        );
                      } else {
                        // Mobile layout
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Video player for mobile (larger)
                            Container(
                              width: 350,
                              height: 250,
                              margin: const EdgeInsets.only(bottom: 40),
                              child: _buildVideoPlayer(),
                            ),
                            // Animated icon
                            AnimatedBuilder(
                              animation: _heroAnimationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 0.8 + (_heroAnimationController.value * 0.2),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          spreadRadius: 0,
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.volunteer_activism,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                            // Title
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Colors.white70],
                              ).createShader(bounds),
                              child: const Text(
                                "Charity Fundraising\nGoal Tracker",
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.1,
                                  letterSpacing: -1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Subtitle
                            Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: const Text(
                                "Transform your fundraising efforts with beautiful, real-time progress tracking. Perfect for charities, nonprofits, and community initiatives.",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // CTA Button
                            if (!isAuthenticated)
                              AnimatedBuilder(
                                animation: _heroAnimationController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - _heroAnimationController.value)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.3),
                                            spreadRadius: 0,
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () => context.push(RouteNames.singIn),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF6366F1),
                                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          "Get Started Free",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AnimatedBuilder(
      animation: _heroAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_heroAnimationController.value * 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                height: 400,
                color: Colors.black.withOpacity(0.1),
                child: _isVideoInitialized
                    ? VideoPlayer(_videoController)
                    : Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesSection() {
    return FadeTransition(
      opacity: _featuresFadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Column(
          children: [
            Semantics(
              header: true,
              child: const Text(
                "Why Choose Our Platform?",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 60),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeatureCard(
                        Icons.trending_up,
                        "Real-time Tracking",
                        "Monitor your fundraising progress with live updates and beautiful visualizations.",
                        0,
                      ),
                      _buildFeatureCard(
                        Icons.analytics,
                        "Advanced Analytics",
                        "Get detailed insights into your donation patterns and campaign performance.",
                        1,
                      ),
                      _buildFeatureCard(
                        Icons.share,
                        "Easy Sharing",
                        "Share your progress with supporters through beautiful, shareable charts.",
                        2,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildFeatureCard(
                        Icons.trending_up,
                        "Real-time Tracking",
                        "Monitor your fundraising progress with live updates and beautiful visualizations.",
                        0,
                      ),
                      const SizedBox(height: 30),
                      _buildFeatureCard(
                        Icons.analytics,
                        "Advanced Analytics",
                        "Get detailed insights into your donation patterns and campaign performance.",
                        1,
                      ),
                      const SizedBox(height: 30),
                      _buildFeatureCard(
                        Icons.share,
                        "Easy Sharing",
                        "Share your progress with supporters through beautiful, shareable charts.",
                        2,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, int index) {
    return AnimatedBuilder(
      animation: _featuresAnimationController,
      builder: (context, child) {
        final delay = index * 0.2;
        final animationValue = (_featuresAnimationController.value - delay).clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 350),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
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
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoSection() {
    return FadeTransition(
      opacity: _videoFadeAnimation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            Semantics(
              header: true,
              child: const Text(
                "How to Create & Track Your Fundraising Chart",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Step-by-step guide to get you started",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Container(
              constraints: const BoxConstraints(maxWidth: 900),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: HtmlWidget(
                    '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/Jo5p091lzho?si=bsPsSkDEPrf1fSeH" frameborder="0" allowfullscreen></iframe>',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInCTA(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFA855F7),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.rocket_launch,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Semantics(
            header: true,
            child: const Text(
              "Ready to Start Your Fundraising Journey?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Text(
              "Join thousands of organizations already using our platform to track and visualize their fundraising progress.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => context.push(RouteNames.singIn),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Get Started Free",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
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
            Color(0xFFF8FAFC),
            Color(0xFFF1F5F9),
          ],
        ),
      ),
      child: Column(
        children: [
          // Main footer content
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // Top section with app info and features
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 1000) {
                      // Desktop layout
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left section - App branding and description
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.volunteer_activism,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Charity Fundraising Goal Tracker",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "The ultimate platform for non-profit organizations",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Track your fundraising progress, manage donations, and visualize your impact with beautiful, real-time charts. Built with love for organizations that want to make a difference.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          // Middle section - Key Features
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Key Features",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildFeatureItem("Real-time Tracking", Icons.trending_up),
                                _buildFeatureItem("Donation Management", Icons.monetization_on),
                                _buildFeatureItem("Progress Visualization", Icons.analytics),
                                _buildFeatureItem("Member Management", Icons.people),
                                _buildFeatureItem("Campaign Analytics", Icons.bar_chart),
                                _buildFeatureItem("Secure Platform", Icons.security),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          // Right section - Support & Resources
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Support & Resources",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildLinkItem("GitHub Repository", Icons.code, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart")),
                                _buildLinkItem("Report Issues", Icons.bug_report, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart/issues")),
                                _buildLinkItem("Feature Requests", Icons.lightbulb, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart/issues")),
                                _buildLinkItem("Documentation", Icons.help, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart")),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          // Far right section - Connect & Founder
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Connect With Us",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildLinkItem("Community FlutterGoo", Icons.people, () => _launchUrl("https://github.com/fluttergoo")),
                                _buildLinkItem("GitHub Page", Icons.open_in_new, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart")),
                                const SizedBox(height: 24),
                                const Text(
                                  "Meet Community Founder",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildLinkItem("LinkedIn", Icons.work, () => _launchUrl("https://www.linkedin.com/in/suleymansurucu/")),
                                _buildLinkItem("Email", Icons.email, () => _sendEmail()),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Mobile layout
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App branding section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.volunteer_activism,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      "Charity Fundraising Goal Tracker",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "The ultimate platform for non-profit organizations",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Track your fundraising progress, manage donations, and visualize your impact with beautiful, real-time charts. Built with love for organizations that want to make a difference.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          // Features and links in mobile layout
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Key Features",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFeatureItem("Real-time Tracking", Icons.trending_up),
                                    _buildFeatureItem("Donation Management", Icons.monetization_on),
                                    _buildFeatureItem("Progress Visualization", Icons.analytics),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Support",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLinkItem("GitHub", Icons.code, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart")),
                                    _buildLinkItem("Issues", Icons.bug_report, () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart/issues")),
                                    _buildLinkItem("Community", Icons.people, () => _launchUrl("https://github.com/fluttergoo")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Founder section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Meet Community Founder",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildLinkItem("LinkedIn", Icons.work, () => _launchUrl("https://www.linkedin.com/in/suleymansurucu/")),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildLinkItem("Email", Icons.email, () => _sendEmail()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                // Bottom section - Copyright and legal
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // Desktop layout
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "© 2025 Charity Fundraising Goal Tracker — Community",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart"),
                                  child: const Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6366F1),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart"),
                                  child: const Text(
                                    "Terms of Service",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6366F1),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Mobile layout
                        return Column(
                          children: [
                            const Text(
                              "© 2025 Charity Fundraising Goal Tracker — Community",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart"),
                                  child: const Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6366F1),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () => _launchUrl("https://github.com/suleymansurucu/flutter_fundraising_goal_chart"),
                                  child: const Text(
                                    "Terms of Service",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6366F1),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 16,
                color: const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6366F1),
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
