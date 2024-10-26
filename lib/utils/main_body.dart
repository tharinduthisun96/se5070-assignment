import 'package:flutter/material.dart';
import 'package:gossip_app/utils/colors_const.dart';

class MainBody extends StatelessWidget {
  const MainBody({
    super.key,
    this.appBarTitle,
    this.appBarbackgroundColor,
    this.centerTitle = true,
    this.automaticallyImplyLeading,
    required this.container,
    this.toolbarHeight,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.appbar = true,
    this.floatingActionButton,
  });
  final Widget? appBarTitle;
  final Color? appBarbackgroundColor;
  final bool? centerTitle;
  final bool? automaticallyImplyLeading;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget container;
  final double? toolbarHeight;
  final Widget? bottomNavigationBar;
  final bool? appbar;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      appBar: appbar == true
          ? AppBar(
              toolbarHeight: toolbarHeight,
              title: appBarTitle,
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kDefTextColor,
                  fontSize: 18),
              backgroundColor: appBarbackgroundColor,
              centerTitle: centerTitle,
              automaticallyImplyLeading: automaticallyImplyLeading ?? false,
            )
          : null,
      body: appbar == false
          ? SafeArea(
              child: container,
            )
          : container,
    );
  }
}
