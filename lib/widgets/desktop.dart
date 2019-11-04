import 'package:flutter/material.dart';

// material shadow colors for easy copy/paste
const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class Desktop extends StatelessWidget {
  final Widget desktopContent;

  Desktop({this.desktopContent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // background
        Image.asset(
          "assets/images/background.png",
          fit: BoxFit.cover,
        ),
        desktopContent,
      ],
    );
  }
}

// TODO: make the snaps a bit looser with physics
class Contexts extends StatefulWidget {
  final List<Widget> children;
  final double verticalViewport;
  final physics;

  Contexts({this.children, this.verticalViewport, this.physics});

  @override
  ContextsState createState() => ContextsState();
}

class ContextsState extends State<Contexts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        physics: widget.physics,
        controller: PageController(
          viewportFraction: widget.verticalViewport,
        ),
        scrollDirection: Axis.vertical,
        children: widget.children,
      ),
    );
  }
}

// TODO: don't allow edge apps to go all the way to center
class ContextSection extends StatefulWidget {
  final String header;
  final List<Widget> children;
  final double screenRatio;
  final bool headerVisible;

  ContextSection(
      {@required this.header,
      this.children,
      this.screenRatio,
      this.headerVisible});

  @override
  _ContextSectionState createState() => _ContextSectionState();
}

class _ContextSectionState extends State<ContextSection> {
  Widget build(BuildContext context) {
    double _phoneHeight = MediaQuery.of(context).size.height;
    double _phoneWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Visibility(
          visible: widget.headerVisible,
          child: _ContextHeading(header: widget.header),
        ),
        SizedBox(
          height: widget.screenRatio * _phoneHeight + 20,
          child: PageView(
            physics: BouncingScrollPhysics(),
            key: PageStorageKey<String>(widget.header),
            controller: PageController(
              initialPage: 1,
              viewportFraction: widget.screenRatio + 20 / _phoneWidth,
            ),
            scrollDirection: Axis.horizontal,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}

class _ContextHeading extends StatelessWidget {
  final String header;

  _ContextHeading({@required this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          header,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  final Color color;

  App({this.color = Colors.blue});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: implement zoom on tap (hero the entire _contextSection)
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 2.0),
                blurRadius: 4.0,
                spreadRadius: -1.0,
                color: _kKeyUmbraOpacity),
            BoxShadow(
                offset: Offset(0.0, 4.0),
                blurRadius: 5.0,
                spreadRadius: 0.0,
                color: _kKeyPenumbraOpacity),
            BoxShadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                color: _kAmbientShadowOpacity),
          ],
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
