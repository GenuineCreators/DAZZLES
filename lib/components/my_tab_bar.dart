// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;
  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
          controller: tabController,
          isScrollable: false,
          labelPadding: EdgeInsets.only(left: 0, right: 0),
          // labelPadding: EdgeInsets.only(left: 0, right: 0),
          tabs: [
            //tab 1
            Tab(
              text: "Exterior ",
            ),
            //tab 2
            Tab(
              text: "Interior ",
            ),
            Tab(
              text: "Full ",
            ),
            //tab 3
            Tab(
              text: "Polish & Wax",
            )
          ]),
    );
  }
}
