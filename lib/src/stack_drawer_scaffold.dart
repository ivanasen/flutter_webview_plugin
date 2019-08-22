import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class StackDrawerScaffold extends StatefulWidget {
  const StackDrawerScaffold({
    Key key,
    this.drawer,
    this.endDrawer,
    this.body,
    this.actions,
    this.title,
    this.onDrawerOpened,
    this.onDrawerClosed,
    this.mainContentPressedStream,
  }) : super(key: key);

  final Widget drawer;
  final Widget endDrawer;
  final Text title;
  final List<Widget> actions;
  final Widget body;
  final Stream<Null> mainContentPressedStream;

  final void Function(bool isLeft) onDrawerOpened;
  final void Function(bool isLeft) onDrawerClosed;

  @override
  State<StatefulWidget> createState() => StackDrawerScaffoldState();
}

class StackDrawerScaffoldState extends State<StackDrawerScaffold>
    with TickerProviderStateMixin {
  static const double _defaultDrawerWidth = 340;
  static const int _drawerAnimationDurationMillis = 250;
  static const int _mainScreenLeftOverWidth = 60;

  bool _drawerOpened = false;
  bool _endDrawerOpened = false;
  AnimationController _drawerAnimationController;
  AnimationController _endDrawerAnimationController;
  StreamSubscription<Null> _mainContentPressedSubscription;

  double _drawerWidth;

  @override
  void initState() {
    super.initState();

    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _drawerAnimationDurationMillis),
    );
    _endDrawerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _drawerAnimationDurationMillis),
    );

    _mainContentPressedSubscription =
        widget.mainContentPressedStream.listen((_) {
      if (_drawerOpened) {
        _toggleDrawer();
      } else if (_endDrawerOpened) {
        _toggleEndDrawer();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateDrawerWidth();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          _buildAnimatedDrawer(),
          _buildAnimatedEndDrawer(),
          _buildAnimatedMainContent(
            Scaffold(
              appBar: _buildAppBar(),
              body: widget.body,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _drawerAnimationController.dispose();
    _endDrawerAnimationController.dispose();
    _mainContentPressedSubscription?.cancel();
  }

  Widget _buildAnimatedMainContent(Widget content) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _drawerAnimationDurationMillis),
      curve: Curves.linearToEaseOut,
      left: _drawerOpened ? _drawerWidth : _endDrawerOpened ? -_drawerWidth : 0,
      right:
          _drawerOpened ? -_drawerWidth : _endDrawerOpened ? _drawerWidth : 0,
      top: 0,
      bottom: 0,
      child: content,
    );
  }

  Widget _buildAnimatedDrawer() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _drawerAnimationDurationMillis),
      curve: Curves.linearToEaseOut,
      left: _drawerOpened ? 0 : -_drawerWidth,
      top: 0,
      bottom: 0,
      child: Container(
        height: double.infinity,
        width: _drawerWidth,
        child: widget.drawer,
      ),
    );
  }

  Widget _buildAnimatedEndDrawer() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _drawerAnimationDurationMillis),
      curve: Curves.linearToEaseOut,
      right: _endDrawerOpened ? 0 : -_drawerWidth,
      top: 0,
      bottom: 0,
      child: Container(
        height: double.infinity,
        width: _drawerWidth,
        child: widget.endDrawer,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: widget.drawer != null ? _buildDrawerMenuButton() : null,
      actions: _buildAppBarActions(),
      title: widget.title,
    );
  }

  Widget _buildDrawerMenuButton() {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _drawerAnimationController,
        ),
        onPressed: _toggleDrawer);
  }

  void _toggleDrawer() {
    if (_endDrawerOpened) {
      return;
    }

    setState(() {
      _drawerOpened = !_drawerOpened;
      if (_drawerOpened) {
        _drawerAnimationController.forward();
        widget.onDrawerOpened(true);
      } else {
        _drawerAnimationController.reverse();
        widget.onDrawerClosed(true);
      }
    });
  }

  void _toggleEndDrawer() {
    if (_drawerOpened) {
      return;
    }

    setState(() {
      _endDrawerOpened = !_endDrawerOpened;
      if (_endDrawerOpened) {
        _endDrawerAnimationController.forward();
        widget.onDrawerOpened(false);
      } else {
        _endDrawerAnimationController.reverse();
        widget.onDrawerOpened(false);
      }
    });
  }

  Widget _buildEndDrawerMenuButton() {
    return IconButton(
      // Turn the back button on the right drawer by 180 degrees
      icon: RotatedBox(
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _endDrawerAnimationController,
        ),
        quarterTurns: 2,
      ),
      onPressed: _toggleEndDrawer,
    );
  }

  List<Widget> _buildAppBarActions() {
    final List<Widget> appBarActions = widget.actions ?? [];
    if (widget.endDrawer != null) {
      appBarActions.add(_buildEndDrawerMenuButton());
    }
    return appBarActions;
  }

  void _calculateDrawerWidth() {
    final MediaQueryData queryData = MediaQuery.of(context);
    _drawerWidth = min(
        queryData.size.width - _mainScreenLeftOverWidth, _defaultDrawerWidth);
  }
}
