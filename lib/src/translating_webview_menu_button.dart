import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TranslatingWebViewMenuButton extends StatelessWidget {
  const TranslatingWebViewMenuButton(
      {Key key, @required this.scaffoldKey, @required this.webViewPlugin})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final FlutterWebviewPlugin webViewPlugin;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        scaffoldKey.currentState.openDrawer();
        webViewPlugin.handleLeftDrawerOpened();
      },
    );
  }
}
