import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_webview_plugin/src/stack_drawer_scaffold.dart';
import 'package:flutter_webview_plugin/src/webview_placeholder.dart';

class StackDrawerWebviewScaffold extends StatefulWidget {
  const StackDrawerWebviewScaffold({
    Key key,
    @required this.url,
    this.drawer,
    this.endDrawer,
    this.actions,
    this.headers,
    this.withJavascript,
    this.clearCache,
    this.clearCookies,
    this.enableAppScheme,
    this.userAgent,
    this.primary = true,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.withZoom,
    this.withLocalStorage,
    this.withLocalUrl,
    this.scrollBar,
    this.supportMultipleWindows,
    this.appCacheEnabled,
    this.hidden = false,
    this.initialChild,
    this.allowFileURLs,
    this.resizeToAvoidBottomInset = false,
    this.invalidUrlRegex,
    this.geolocationEnabled,
    this.debuggingEnabled = false,
    this.title,
    this.javascriptChannels,
  }) : super(key: key);

  final Widget drawer;
  final Widget endDrawer;
  final Text title;
  final List<Widget> actions;
  final Map<String, String> headers;
  final bool withJavascript;
  final bool clearCache;
  final bool clearCookies;
  final bool enableAppScheme;
  final String userAgent;
  final bool primary;
  final List<Widget> persistentFooterButtons;
  final Widget bottomNavigationBar;
  final bool withZoom;
  final bool withLocalStorage;
  final bool withLocalUrl;
  final bool scrollBar;
  final bool supportMultipleWindows;
  final bool appCacheEnabled;
  final bool hidden;
  final Widget initialChild;
  final bool allowFileURLs;
  final bool resizeToAvoidBottomInset;
  final String invalidUrlRegex;
  final bool geolocationEnabled;
  final bool debuggingEnabled;
  final String url;
  final Set<JavascriptChannel> javascriptChannels;

  @override
  State<StatefulWidget> createState() => StackDrawerWebviewScaffoldState();
}

class StackDrawerWebviewScaffoldState extends State<StackDrawerWebviewScaffold>
    with TickerProviderStateMixin {
  final FlutterWebviewPlugin _webviewReference = FlutterWebviewPlugin();
  Rect _rect;

  StreamSubscription<Null> _onBack;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void initState() {
    super.initState();

    _webviewReference.close();

    _onBack = _webviewReference.onBack.listen((_) async {
      if (!mounted) {
        return;
      }

      // The willPop/pop pair here is equivalent to Navigator.maybePop(),
      // which is what's called from the flutter back button handler.
      final RoutePopDisposition pop = await _topMostRoute.willPop();
      if (pop == RoutePopDisposition.pop) {
        // Close the webview if it's on the route at the top of the stack.
        final isOnTopMostRoute = _topMostRoute == ModalRoute.of(context);
        if (isOnTopMostRoute) {
          _webviewReference.close();
        }
        Navigator.pop(context);
      }
    });

    if (widget.hidden) {
      _onStateChanged =
          _webviewReference.onStateChanged.listen((WebViewStateChanged state) {
        if (state.type == WebViewState.finishLoad) {
          _webviewReference.show();
        }
      });
    }
  }

  /// Equivalent to [Navigator.of(context)._history.last].
  Route<dynamic> get _topMostRoute {
    Route topMost;
    Navigator.popUntil(context, (Route route) {
      topMost = route;
      return true;
    });
    return topMost;
  }

  @override
  Widget build(BuildContext context) {
    return StackDrawerScaffold(
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      onDrawerOpened: (_) => _webviewReference.setWebviewTouchesEnabled(false),
      onDrawerClosed: (_) => _webviewReference.setWebviewTouchesEnabled(true),
      mainContentPressedStream: _webviewReference.onDisabledWebviewTouched,
      body: WebviewPlaceholder(
        onRectChanged: (Rect value) {
          if (_rect == null) {
            _rect = value;
            _webviewReference.launch(
              widget.url,
              headers: widget.headers,
              withJavascript: widget.withJavascript,
              clearCache: widget.clearCache,
              clearCookies: widget.clearCookies,
              hidden: widget.hidden,
              enableAppScheme: widget.enableAppScheme,
              userAgent: widget.userAgent,
              rect: _rect,
              withZoom: widget.withZoom,
              withLocalStorage: widget.withLocalStorage,
              withLocalUrl: widget.withLocalUrl,
              scrollBar: widget.scrollBar,
              supportMultipleWindows: widget.supportMultipleWindows,
              appCacheEnabled: widget.appCacheEnabled,
              allowFileURLs: widget.allowFileURLs,
              invalidUrlRegex: widget.invalidUrlRegex,
              geolocationEnabled: widget.geolocationEnabled,
              debuggingEnabled: widget.debuggingEnabled,
              javascriptChannels: widget.javascriptChannels,
            );
          } else {
            if (_rect != value) {
              _rect = value;
              _webviewReference.resize(_rect);
            }
          }
        },
        child: widget.initialChild ??
            const Center(child: const CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _webviewReference.close();
    _webviewReference.dispose();
    _onBack?.cancel();
    _onStateChanged?.cancel();
  }
}
