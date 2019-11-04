import 'package:flutter/material.dart';
import 'package:new_ui/widgets/drawer.dart';
import 'package:new_ui/widgets/desktop.dart';
import 'package:new_ui/data/desktop_state.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _phoneHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer slider (wants to be root for whatever reason)
      body: DrawerSlider(
        minHeight: 0,
        under: Desktop(
          desktopContent: DesktopContent(
            headerVisible: false,
            screenRatio: 1,
            verticalViewport: 1 + 20 / _phoneHeight,
            vertPhysics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
