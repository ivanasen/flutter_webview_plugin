import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class DrawerAnimationManager {
  static const int _drawerCloseAnimationMillis = 200;
  static const int _drawerOpenAnimationMillis = 270;
  static const int _drawerWidth = 304;

  final FlutterWebviewPlugin webviewPlugin = FlutterWebviewPlugin();

  Future<Null> handleDrawerClosed() async {
    return await webviewPlugin.translateWithAnimation(
        0, 0, const Duration(milliseconds: _drawerCloseAnimationMillis));
  }

  Future<Null> handleDrawerOpened() async {
    return await webviewPlugin.translateWithAnimation(_drawerWidth, 0,
        const Duration(milliseconds: _drawerOpenAnimationMillis));
  }

  Future<Null> handleEndDrawerClosed() async {
    return await webviewPlugin.translateWithAnimation(
        0, 0, const Duration(milliseconds: _drawerCloseAnimationMillis));
  }

  Future<Null> handleEndDrawerOpened() async {
    return await webviewPlugin.translateWithAnimation(-_drawerWidth, 0,
        const Duration(milliseconds: _drawerOpenAnimationMillis));
  }
}
