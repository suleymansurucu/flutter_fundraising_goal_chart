import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final List<Widget>? actions;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Constants.primary,
    this.textColor = Colors.white,
    this.actions,
    this.scaffoldKey,
  });



  @override
  State<CustomAppBar> createState() => _CustomAppBarState();


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    _getFullName(context);
    super.initState();
  }
  String? fullName;

  @override
  Consumer<UserViewModels> build(BuildContext context) {
     final userViewModels = Provider.of<UserViewModels>(context, listen: false);



    return Consumer<UserViewModels>(
      builder: (context, userViewModels, child) {
        return AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: widget.textColor, fontWeight: FontWeight.bold),
          ),

          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.indigo.shade500,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              widget.scaffoldKey?.currentState?.openDrawer();
            },
          ),
          actions: [
            if (fullName != null && fullName!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text("Hello, $fullName!",
                        style: TextStyle(color: widget.textColor)),
                    TextButton(
                      onPressed: () async {
                        await userViewModels.signOutWithEmailAndPassword(
                            userViewModels.userModel!.userID);
                        if (context.mounted) {
                          context.push(RouteNames.home);
                        }
                      },
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  context.push(RouteNames.singIn);
                },
                child: Text(
                  'Sign In',
                  style:
                      TextStyle(color: widget.textColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            if (widget.actions != null) ...widget.actions!,
          ],
        );
      },
    );
  }



  void _getFullName(BuildContext context) async {
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    final _userviewModel = await userViewModels.getUserData(userViewModels.userModel!.userID);

    fullName = _userviewModel!.fullName;
  }
}
