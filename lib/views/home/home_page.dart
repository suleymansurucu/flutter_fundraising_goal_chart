import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scafoldHomeKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldHomeKey,
      appBar: CustomAppBar(
        title: 'Home',
        scaffoldKey: _scafoldHomeKey,
      ),
      drawer: BuildDrawMenu(),
    );
  }
}
