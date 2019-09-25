import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Animation logic taken from flutter's drawer.dart
class AnimatedDrawerWrapper extends StatefulWidget {
  const AnimatedDrawerWrapper(
      {Key key,
      @required this.drawer,
      this.isEndPositioned = false,
      this.onDrawerToggled,
      this.width = maxDrawerWidth,
      this.drawerToggleStream})
      : super(key: key);

  static const double maxDrawerWidth = 340;
  static const int drawerAnimationDurationMillis = 250;

  final bool isEndPositioned;
  final Widget drawer;
  final double width;
  final void Function(bool opened) onDrawerToggled;
  final Stream<Null> drawerToggleStream;

  @override
  State<StatefulWidget> createState() => _AnimatedDrawerWrapperState();
}

class _AnimatedDrawerWrapperState extends State<AnimatedDrawerWrapper>
    with SingleTickerProviderStateMixin {
  bool _opened = false;
  LocalHistoryEntry _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();

    widget.drawerToggleStream?.listen((_) {
      if (_opened) {
        Navigator.of(context).pop();
      } else {
        _toggle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(
          milliseconds: AnimatedDrawerWrapper.drawerAnimationDurationMillis),
      curve: Curves.linearToEaseOut,
      left: widget.isEndPositioned ? null : _opened ? 0 : -widget.width,
      right: widget.isEndPositioned ? _opened ? 0 : -widget.width : null,
      top: 0,
      bottom: 0,
      child: Container(
        height: double.infinity,
        width: widget.width,
        child: widget.drawer,
      ),
    );
  }

  void _ensureHistoryEntry() {
    final ModalRoute<dynamic> route = ModalRoute.of(context);
    if (route != null) {
      _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
      route.addLocalHistoryEntry(_historyEntry);
      FocusScope.of(context).setFirstFocus(_focusScopeNode);
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    _toggle();
  }

  void _toggle() {
    setState(() {
      _opened = !_opened;
      if (_opened) {
        widget.onDrawerToggled?.call(true);
        _ensureHistoryEntry();
      } else {
        widget.onDrawerToggled?.call(false);
        _historyEntry?.remove();
        _historyEntry = null;
      }
    });
  }
}
