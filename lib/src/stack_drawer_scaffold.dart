import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/src/stack_drawer_app_bar.dart';

class StackDrawerScaffold extends StatefulWidget {
  const StackDrawerScaffold(
      {Key key, this.appBar, this.drawer, this.endDrawer, this.body})
      : super(key: key);

  final StackDrawerAppBar appBar;
  final Widget drawer;
  final Widget endDrawer;
  final Widget body;

  @override
  State<StatefulWidget> createState() => StackDrawerScaffoldState();

  static StackDrawerScaffoldState of(BuildContext context,
      {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final StackDrawerScaffoldState result = context
        .ancestorStateOfType(const TypeMatcher<StackDrawerScaffoldState>());
    if (nullOk || result != null) {
      return result;
    }

    throw FlutterError(
        'StackDrawerScaffolfState.of() called with a context that does not contain a StackDrawerScaffold.\n'
        'No StackDrawerScaffold ancestor could be found starting from the context that was passed to StackDrawerScaffold.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the StackDrawerScaffold widget being sought.\n'
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the StackDrawerScaffold. For an example of this, please see the '
        'documentation for StackDrawerScaffold.of():\n'
        '  https://api.flutter.dev/flutter/material/StackDrawerScaffold/of.html\n'
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the StackDrawerScaffold. In this solution, '
        'you would have an outer widget that creates the StackDrawerScaffold populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use StackDrawerScaffold.of().\n'
        'A less elegant but more expedient solution is assign a GlobalKey to the StackDrawerScaffold, '
        'then use the key.currentState property to obtain the StackDrawerScaffoldState rather than '
        'using the StackDrawerScaffold.of() function.\n'
        'The context used was:\n'
        '  $context');
  }
}

class StackDrawerScaffoldState extends State<StackDrawerScaffold> {
  static const double _drawerMenuWidth = 300;
  static const int _drawerAnimationDurationMillis = 250;

  bool _drawerOpened = false;
  bool _endDrawerOpened = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: _drawerMenuWidth,
            child: widget.drawer,
          ),
          _buildAnimatedContent(
              Scaffold(
                body: widget.body,
              ),
              _drawerOpened),
        ],
      ),
    );
  }

  void openDrawer() {
    setState(() {
      _drawerOpened = true;
    });
  }

  void openEndDrawer() {
    setState(() {
      _endDrawerOpened = true;
    });
  }

  Widget _buildAnimatedContent(Widget content, bool opened) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _drawerAnimationDurationMillis),
      curve: Curves.linearToEaseOut,
      left: opened ? _drawerMenuWidth : 0,
      top: 0,
      right: opened ? -_drawerMenuWidth : 0,
      bottom: 0,
      child: DecoratedBox(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              spreadRadius: 8,
              blurRadius: 16,
            )
          ]),
          child: content),
    );
  }
}
