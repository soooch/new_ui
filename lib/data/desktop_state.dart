import 'package:flutter/material.dart';
import 'package:new_ui/widgets/desktop.dart';

// TODO: make this stateful when dynamic
class DesktopContent extends StatefulWidget {
  final double screenRatio;
  final double verticalViewport;
  final vertPhysics;
  final bool headerVisible;

  DesktopContent(
      {this.screenRatio = .6,
      this.verticalViewport = .7,
      this.vertPhysics,
      this.headerVisible = true});

  @override
  _DesktopContentState createState() => _DesktopContentState();
}

class _DesktopContentState extends State<DesktopContent> {
  @override
  Widget build(BuildContext context) {
    return Contexts(
      physics: widget.vertPhysics,
      verticalViewport: widget.verticalViewport,
      children: <Widget>[
        ContextSection(
          header: "Work",
          headerVisible: widget.headerVisible,
          screenRatio: widget.screenRatio,
          children: <Widget>[
            App(color: Colors.yellow),
            App(color: Colors.deepPurple),
            App(color: Colors.tealAccent),
          ],
        ),
        ContextSection(
          header: "Social",
          headerVisible: widget.headerVisible,
          screenRatio: widget.screenRatio,
          children: <Widget>[
            App(color: Colors.pinkAccent),
            App(color: Colors.blue),
            App(color: Colors.orange),
          ],
        ),
        ContextSection(
          header: "Home",
          headerVisible: widget.headerVisible,
          screenRatio: widget.screenRatio,
          children: <Widget>[
            App(color: Colors.indigo),
            App(color: Colors.grey[800]),
            App(color: Colors.deepOrange),
            App(color: Colors.blueGrey),
          ],
        ),
      ],
    );
  }
}
