import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/src/base.dart';

class WebviewAutoHideNavigatorObserver extends NavigatorObserver {
  final FlutterWebviewPlugin plugin = FlutterWebviewPlugin();

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    plugin.hide();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    plugin.show();
  }
}
