import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/src/animated_drawer_wrapper.dart';

class StackDrawerScaffold extends StatefulWidget {
  const StackDrawerScaffold({
    Key key,
    this.drawer,
    this.endDrawer,
    this.body,
    this.onDrawerToggled,
    this.onEndDrawerToggled,
    this.appBar,
    this.mainContentElevation = 4.0,
  }) : super(key: key);

  final Widget drawer;
  final Widget endDrawer;
  final Widget body;
  final AppBar appBar;
  final double mainContentElevation;

  final void Function(bool opened) onDrawerToggled;
  final void Function(bool opened) onEndDrawerToggled;

  @override
  State<StatefulWidget> createState() => StackDrawerScaffoldState();
}

class StackDrawerScaffoldState extends State<StackDrawerScaffold>
    with TickerProviderStateMixin {
  static const int _mainScreenLeftOverWidth = 60;

  bool _drawerOpened = false;
  bool _endDrawerOpened = false;
  double _drawerWidth;

  AnimationController _drawerButtonAnimationController;
  AnimationController _endDrawerButtonAnimationController;

  final StreamController<Null> _drawerToggleStream = StreamController();
  final StreamController<Null> _endDrawerToggleStream = StreamController();

  @override
  void initState() {
    super.initState();

    _drawerButtonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: AnimatedDrawerWrapper.drawerAnimationDurationMillis),
    );
    _endDrawerButtonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: AnimatedDrawerWrapper.drawerAnimationDurationMillis),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          AnimatedDrawerWrapper(
            width: _drawerWidth,
            isEndPositioned: false,
            drawer: widget.drawer,
            onDrawerToggled: _handleDrawerToggled,
            drawerToggleStream: _drawerToggleStream.stream,
          ),
          AnimatedDrawerWrapper(
            width: _drawerWidth,
            isEndPositioned: true,
            drawer: widget.endDrawer,
            onDrawerToggled: _handleEndDrawerToggled,
            drawerToggleStream: _endDrawerToggleStream.stream,
          ),
          _buildAnimatedContent(_buildScaffold()),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateDrawerWidth();
  }

  Widget _buildAnimatedContent(Widget content) {
    return AnimatedPositioned(
      duration: Duration(
          milliseconds: AnimatedDrawerWrapper.drawerAnimationDurationMillis),
      curve: Curves.linearToEaseOut,
      left: _drawerOpened ? _drawerWidth : _endDrawerOpened ? -_drawerWidth : 0,
      right:
          _drawerOpened ? -_drawerWidth : _endDrawerOpened ? _drawerWidth : 0,
      top: 0,
      bottom: 0,
      child: content,
    );
  }

  Widget _buildScaffold() {
    return Card(
      elevation: widget.mainContentElevation,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: GestureDetector(
          onTap: () {
            if (_drawerOpened) {
              _drawerToggleStream.sink.add(null);
            } else if (_endDrawerOpened) {
              _endDrawerToggleStream.sink.add(null);
            }
          },
          child: widget.body,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    if (widget.appBar != null) {
      return AppBar(
        key: widget.appBar?.key,
        elevation: widget.appBar.elevation,
        leading: widget.drawer != null
            ? _buildDrawerMenuButton()
            : widget.appBar.leading,
        actions: _buildAppBarActions(),
        title: widget.appBar?.title,
        actionsIconTheme: widget.appBar?.actionsIconTheme,
        automaticallyImplyLeading: widget.appBar?.automaticallyImplyLeading,
        toolbarOpacity: widget.appBar?.toolbarOpacity,
        backgroundColor: widget.appBar?.backgroundColor,
        bottomOpacity: widget.appBar?.bottomOpacity,
        brightness: widget.appBar?.brightness,
        centerTitle: widget.appBar?.centerTitle,
        flexibleSpace: widget.appBar?.flexibleSpace,
        iconTheme: widget.appBar?.iconTheme,
        primary: widget.appBar?.primary,
        shape: widget.appBar?.shape,
        textTheme: widget.appBar?.textTheme,
        titleSpacing: widget.appBar?.titleSpacing,
        bottom: widget.appBar?.bottom != null
            ? widget.appBar.bottom
            : _buildDefaultAppBarBottom(),
      );
    }

    return AppBar(
      leading: _buildDrawerMenuButton(),
      actions: _buildAppBarActions(),
      bottom: _buildDefaultAppBarBottom(),
    );
  }

  Widget _buildDrawerMenuButton() {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _drawerButtonAnimationController,
        ),
        onPressed: () => _drawerToggleStream.sink.add(null));
  }

  Widget _buildEndDrawerMenuButton() {
    return IconButton(
      // Turn the back button on the right drawer by 180 degrees
      icon: RotatedBox(
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _endDrawerButtonAnimationController,
        ),
        quarterTurns: 2,
      ),
      onPressed: () => _endDrawerToggleStream.sink.add(null),
    );
  }

  List<Widget> _buildAppBarActions() {
    final List<Widget> appBarActions = List.from(widget.appBar?.actions ?? []);
    if (widget.endDrawer != null) {
      appBarActions.add(_buildEndDrawerMenuButton());
    }
    return appBarActions;
  }

  void _calculateDrawerWidth() {
    final MediaQueryData queryData = MediaQuery.of(context);
    _drawerWidth = min(queryData.size.width - _mainScreenLeftOverWidth,
        AnimatedDrawerWrapper.maxDrawerWidth);
  }

  Widget _buildDefaultAppBarBottom() => PreferredSize(
        child: Container(color: Colors.black.withAlpha(20), height: 1),
        preferredSize: Size.fromHeight(1),
      );

  void _handleDrawerToggled(bool opened) {
    if (opened) {
      _drawerButtonAnimationController.forward();
    } else {
      _drawerButtonAnimationController.reverse();
    }

    setState(() {
      _drawerOpened = opened;
    });

    widget.onDrawerToggled != null ? widget.onDrawerToggled(opened) : null;
  }

  void _handleEndDrawerToggled(bool opened) {
    if (opened) {
      _endDrawerButtonAnimationController.forward();
    } else {
      _endDrawerButtonAnimationController.reverse();
    }

    setState(() {
      _endDrawerOpened = opened;
    });

    widget.onEndDrawerToggled != null
        ? widget.onEndDrawerToggled(opened)
        : null;
  }
}
