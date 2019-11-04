import 'package:flutter/material.dart';
import 'package:new_ui/widgets/desktop.dart';
import 'package:new_ui/widgets/drawer.dart';
import 'package:new_ui/data/desktop_state.dart';

class SwitcherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer slider (wants to be root for whatever reason)
      body: DrawerSlider(
        minHeight: 60,
        under: Desktop(
          desktopContent: DesktopContent(
            headerVisible: true,
            screenRatio: .6,
            verticalViewport: .7,
            vertPhysics: BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
