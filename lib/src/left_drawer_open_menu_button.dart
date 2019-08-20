import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_webview_plugin/src/drawer_animation_manager.dart';

class LeftDrawerOpenMenuButton extends StatelessWidget {
  const LeftDrawerOpenMenuButton(
      {Key key, @required this.scaffoldKey, @required this.drawerManager})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final DrawerAnimationManager drawerManager;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        scaffoldKey.currentState.openDrawer();
        drawerManager.handleDrawerOpened();
      },
    );
  }
}
