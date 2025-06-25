//
//  Author: 				Jiří Sedlák (xsedla2e)
//  Create Time: 		03-05-2025 13:44:42
//  Modified time: 	13-05-2025 22:41:44
//  Description: 		This file contains settings page wrapper, that displays multiple pages with tabs
//

import 'package:flutter/material.dart';

class SettingsPageWrapper extends StatefulWidget {
  final List<NavigationDestination> destinations;
  final List<Widget> pages;
  final int triggerCounter;

  const SettingsPageWrapper({
    super.key, 
    required this.destinations, 
    required this.pages,
    this.triggerCounter = 0
  });

  @override
  State<SettingsPageWrapper> createState() => _SettingsPageWrapperState();
}

class _SettingsPageWrapperState extends State<SettingsPageWrapper>{
  int _currentPage = 0;

  @override
  void didUpdateWidget(covariant SettingsPageWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.triggerCounter != widget.triggerCounter) {
      setState(() {
        _currentPage = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: NavigationBar(
        destinations: widget.destinations,
        selectedIndex: _currentPage,
        onDestinationSelected: (newPage) => setState(() => _currentPage = newPage),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: widget.pages[_currentPage]
          ),
        )
      ),
    );
  }
}