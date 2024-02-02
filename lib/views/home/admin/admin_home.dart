import 'package:event/utils/constant.dart';
import 'package:event/views/home/admin/all_events.dart';
import 'package:event/views/home/admin/create_event.dart';
import 'package:event/views/home/admin/profile.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey bottomNavigationKey = GlobalKey();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: IndexedStack(
          index: currentPage,
          children: const [
            AllEvents(),
            CreateEvent(),
            Profile(),
          ],
        ),
        backgroundColor: Constants.primaryColor,
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Constants.primaryColor,
          inactiveIconColor: Constants.primaryColor,
          textColor: Constants.primaryColor,
          tabs: [
            TabData(iconData: Icons.dashboard, title: "Events"),
            TabData(iconData: Icons.create_new_folder, title: "Create"),
            TabData(iconData: Icons.person, title: "Profile")
          ],
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      ),
    );
  }
}