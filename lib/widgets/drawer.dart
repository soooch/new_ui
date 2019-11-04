import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

class DrawerSlider extends StatefulWidget {
  final Widget under;
  final double minHeight;

  DrawerSlider({this.under, this.minHeight = 60});

  @override
  _DrawerSliderState createState() => _DrawerSliderState();
}

//TODO: re-orchestrate all the state changes to move out more methods
class _DrawerSliderState extends State<DrawerSlider> {
  bool _innerDrawerVisible = false;
  bool _innerDrawerIgnored = false;
  PanelController _dc;
  TextEditingController _searchController;

  // TODO: try to store this all in one place
  double _phoneHeight;
  double _phoneWidth;
  double _paddingTop;
  final double _screenRatio = .6;

  static const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
  static const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
  static const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _dc = PanelController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phoneHeight = MediaQuery.of(context).size.height;
    _phoneWidth = MediaQuery.of(context).size.width;
    _paddingTop = MediaQuery.of(context).padding.top;

    return SlidingUpPanel(
      // (drawer controller)
      controller: _dc,
      renderPanelSheet: false,
      minHeight: widget.minHeight,
      maxHeight: _phoneHeight - _paddingTop,
      onPanelClosed: () {
        _searchController.clear();
        FocusScope.of(context).unfocus();
        setState(() {
          _innerDrawerVisible = false;
          _innerDrawerIgnored = false;
        });
      },
      onPanelSlide: (position) {
        setState(() {
          _innerDrawerVisible = true;
          _innerDrawerIgnored = false;
        });
      },
      panel: _drawer(),
      // background
      body: widget.under,
    );
  }

  Widget _drawer() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: min(_screenRatio * max(_phoneWidth, _phoneHeight), _phoneWidth),
        constraints: BoxConstraints(
          minHeight: _phoneHeight - _paddingTop,
          maxWidth: 600,
          minWidth: min(_phoneHeight, _phoneWidth),
        ),
        decoration: BoxDecoration(
          // maybe get a shadow going here
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          color: Theme.of(context).colorScheme.background.withOpacity(.9),
        ),
        alignment: Alignment.topCenter,
        // search box container
        child: Stack(
          children: <Widget>[
            _innerScroll(),
            _searchBar(),
          ],
        ),
      ),
    );
  }

  // TODO: allow scrolling down after scrolling all the way up. (custom scroll physics?)
  Widget _innerScroll() {
    return Visibility(
      visible: _innerDrawerVisible,
      maintainState: true,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) {
          if (scrollState is OverscrollNotification &&
              scrollState.overscroll < 0) {
            setState(() {
              _innerDrawerIgnored = true;
            });
          }
          return false;
        },
        child: IgnorePointer(
          ignoring: _innerDrawerIgnored,
          child: Container(
            padding: EdgeInsets.only(
              top: 30,
            ),
            height: _phoneHeight - _paddingTop,
            //adding a margin to the top leaves an area where the user can swipe
            //to open/close the sliding panel

            child: _InnerScrollContent(),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 1.0,
              spreadRadius: -1.0,
              color: _kKeyUmbraOpacity),
          BoxShadow(
              offset: Offset(0.0, 1.0),
              blurRadius: 1.0,
              spreadRadius: 0.0,
              color: _kKeyPenumbraOpacity),
          BoxShadow(
              offset: Offset(0.0, 1.0),
              blurRadius: 3.0,
              spreadRadius: 0.0,
              color: _kAmbientShadowOpacity),
        ],
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 10),
      child: TextField(
        textInputAction: TextInputAction.search,
        controller: _searchController,
        cursorColor: Colors.grey,
        onTap: () {
          _dc.open();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'search',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

// TODO: split up further maybe?
class _InnerScrollContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        _sliverTopCard(),
        _sliverAppGrid(appCount: 200),
      ],
    );
  }

  Widget _sliverTopCard({String cardType = 'weather'}) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          SizedBox(height: 30),
          Card(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: _weatherCardContent(),
          ),
        ],
      ),
    );
  }

  Widget _sliverAppGrid({int appCount = 50}) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 30,
        bottom: 10,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 60.0,
          mainAxisSpacing: 30.0,
          crossAxisSpacing: 20.0,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.teal[100 * (index % 9)],
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text('App $index'),
            );
          },
          childCount: appCount,
        ),
      ),
    );
  }

  // TODO: should be make stateful whenever it gets dynamic
  Widget _weatherCardContent() {
    return ListTile(
      // sun
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      title: Text('72°F in Overland Park'),
      subtitle: Text('Sunny'),
      trailing: Icon(Icons.more_vert),
    );
  }
}
