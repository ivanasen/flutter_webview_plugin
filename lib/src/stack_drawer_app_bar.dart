import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/src/stack_drawer_scaffold.dart';

class StackDrawerAppBar extends StatefulWidget {
  const StackDrawerAppBar({Key key, this.actions}) : super(key: key);

  final List<Widget> actions;

  @override
  State<StatefulWidget> createState() => _StackDrawerAppBarState();
}

class _StackDrawerAppBarState extends State<StackDrawerAppBar> {
  StackDrawerScaffoldState _scaffoldState;

  @override
  void initState() {
    super.initState();
    _scaffoldState = StackDrawerScaffold.of(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_scaffoldState.widget.endDrawer != null) {
      widget.actions.add(_buildEndDrawerIconButton());
    }

    return AppBar(
      leading: _scaffoldState.widget.drawer != null
          ? _buildDrawerIconButton()
          : null,
      actions: widget.actions,
    );
  }

  Widget _buildDrawerIconButton() {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        StackDrawerScaffold.of(context).openDrawer();
      },
    );
  }

  Widget _buildEndDrawerIconButton() {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        StackDrawerScaffold.of(context).openEndDrawer();
      },
    );
  }
}
