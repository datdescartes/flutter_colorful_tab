library flutter_colorful_tab;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TabItem {
  TabItem({this.color, this.title});
  final Color color;
  final Widget title;
}

class ColorfulTabBar extends StatefulWidget {
  ColorfulTabBar({
    Key key,
    this.tabs,
    this.controller,
    double selectedHeight = 40,
    double unselectedHeight = 32,
    this.indicatorHeight = 4,
    this.topPadding = 8,
    this.verticalTabPadding = 2,
    this.tabShape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(4),
    )),
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.white60,
  })  : assert(selectedHeight > 0),
        assert(unselectedHeight > 0),
        assert(indicatorHeight >= 0),
        tabHeight = max(selectedHeight, unselectedHeight),
        selectedTabPadding =
            max(selectedHeight, unselectedHeight) - selectedHeight,
        unselectedTabPadding =
            max(selectedHeight, unselectedHeight) - unselectedHeight,
        super(key: key);

  final TabController controller;
  final List<TabItem> tabs;
  final double tabHeight;
  final double unselectedTabPadding;
  final double selectedTabPadding;
  final double indicatorHeight;
  final double topPadding;
  final double verticalTabPadding;
  final ShapeBorder tabShape;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  _ColorfulTabBarState createState() => _ColorfulTabBarState();
}

class _ColorfulTabBarState extends State<ColorfulTabBar> {
  ScrollController _scrollController;
  TabController _controller;
  int _currentIndex;
  List<GlobalKey> _tabKeys;
  List<double> _tabOffsets;
  double _tabStripWidth;

  @override
  void initState() {
    super.initState();
    _tabKeys = widget.tabs.map((tab) => GlobalKey()).toList();
    _scrollController = ScrollController();
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    // ignore: omit_local_variable_types
    final TabController newController =
        widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError('No TabController for ${widget.runtimeType}.\n');
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller.animation.removeListener(_handleTabControllerAnimationTick);
      _controller.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller.animation.addListener(_handleTabControllerAnimationTick);
      _controller.addListener(_handleTabControllerTick);
      _currentIndex = _controller.index;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
  }

  @override
  void didUpdateWidget(ColorfulTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
    }

    if (widget.tabs.length > oldWidget.tabs.length) {
      final delta = widget.tabs.length - oldWidget.tabs.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
    } else if (widget.tabs.length < oldWidget.tabs.length) {
      _tabKeys.removeRange(widget.tabs.length, oldWidget.tabs.length);
    }
  }

  @override
  void dispose() {
    if (_controllerIsValid) {
      _controller.animation.removeListener(_handleTabControllerAnimationTick);
      _controller.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller.indexIsChanging) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller.index != _currentIndex) {
      _currentIndex = _controller.index;
      _scrollToSelectedTab();
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller.animateTo(index);
  }

  // Called each time layout completes.
  void _saveTabOffsets(
      List<double> tabOffsets, TextDirection textDirection, double width) {
    _tabStripWidth = width;
    _tabOffsets = tabOffsets;
  }

  double _tabCenteredScrollOffset(int i) {
    var tabCenter = (_tabOffsets[i] + _tabOffsets[i + 1]) / 2;
    final p = _scrollController.position;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        tabCenter = _tabStripWidth - tabCenter;
        break;
      case TextDirection.ltr:
        break;
    }
    return (tabCenter - p.viewportDimension / 2.0)
        .clamp(p.minScrollExtent, p.maxScrollExtent) as double;
  }

  void _scrollToSelectedTab() {
    final pos2Scroll = _tabCenteredScrollOffset(_controller.index);
    _scrollController.animateTo(pos2Scroll,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void _scrollToControllerValue() {
    final leadingPosition =
        _currentIndex > 0 ? _tabCenteredScrollOffset(_currentIndex - 1) : null;
    final middlePosition = _tabCenteredScrollOffset(_currentIndex);
    final trailingPosition = _currentIndex < (_tabOffsets.length - 2)
        ? _tabCenteredScrollOffset(_currentIndex + 1)
        : null;

    final index = _controller.index.toDouble();
    final value = _controller.animation.value;
    double offset;
    if (value == index - 1.0) {
      offset = leadingPosition ?? middlePosition;
    } else if (value == index + 1.0) {
      offset = trailingPosition ?? middlePosition;
    } else if (value == index) {
      offset = middlePosition;
    } else if (value < index) {
      offset = leadingPosition == null
          ? middlePosition
          : lerpDouble(middlePosition, leadingPosition, index - value);
    } else {
      offset = trailingPosition == null
          ? middlePosition
          : lerpDouble(middlePosition, trailingPosition, value - index);
    }
    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (_controller.length != widget.tabs.length) {
        throw FlutterError(
            "Controller's length property (${_controller.length}) does not"
            ' match the number of tabs (${widget.tabs.length}) present in '
            "TabBar's tabs property.");
      }
      return true;
    }());
    if (_controller.length == 0) {
      return Container(
        height: widget.tabHeight + widget.indicatorHeight,
      );
    }

    // ignore: omit_local_variable_types
    final List<Widget> tabs =
        List.generate(widget.tabs.length, (index) => null);

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final previousIndex = _controller.previousIndex;
      if (_controller.indexIsChanging) {
        final Animation<double> animation = _ChangeAnimation(_controller);
        tabs[_currentIndex] = _TabItemWidget(widget,
            onPressed: () => _handleTap(_currentIndex),
            animation: animation,
            selected: true,
            tab: widget.tabs[_currentIndex]);
        tabs[previousIndex] = _TabItemWidget(widget,
            onPressed: () => _handleTap(previousIndex),
            animation: animation,
            selected: false,
            tab: widget.tabs[previousIndex]);
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final tabIndex = _currentIndex;
        final Animation<double> centerAnimation =
            _DragAnimation(_controller, tabIndex);
        tabs[tabIndex] = _TabItemWidget(widget,
            onPressed: () => _handleTap(tabIndex),
            animation: centerAnimation,
            selected: true,
            tab: widget.tabs[_currentIndex]);
        if (_currentIndex > 0) {
          final tabIndex = _currentIndex - 1;
          final Animation<double> previousAnimation =
              ReverseAnimation(_DragAnimation(_controller, tabIndex));
          tabs[tabIndex] = _TabItemWidget(widget,
              onPressed: () => _handleTap(tabIndex),
              animation: previousAnimation,
              selected: false,
              tab: widget.tabs[tabIndex]);
        }
        if (_currentIndex < widget.tabs.length - 1) {
          final tabIndex = _currentIndex + 1;
          final Animation<double> nextAnimation =
              ReverseAnimation(_DragAnimation(_controller, tabIndex));
          tabs[tabIndex] = _TabItemWidget(widget,
              onPressed: () => _handleTap(tabIndex),
              animation: nextAnimation,
              selected: false,
              tab: widget.tabs[tabIndex]);
        }
      }
    }

    for (var index = 0; index < widget.tabs.length; ++index) {
      if (tabs[index] != null) {
        continue;
      }
      final isSelected = widget.controller.index == index;
      tabs[index] = _TabItemWidget(widget,
          onPressed: () => _handleTap(index),
          animation: kAlwaysDismissedAnimation,
          selected: isSelected,
          tab: widget.tabs[index]);
    }

    return Column(
      children: [
        SizedBox(height: widget.topPadding),
        SizedBox(
          height: widget.tabHeight,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: _TabLabelBar(
                onPerformLayout: _saveTabOffsets,
                children: tabs,
              )),
        ),
        _IndicatorWidget(
          animation: _controller?.animation ?? kAlwaysDismissedAnimation,
          tabs: widget.tabs,
          currentIndex: _currentIndex,
          height: widget.indicatorHeight,
        )
      ],
    );
  }
}

class _TabLabelBar extends Flex {
  _TabLabelBar({
    Key key,
    List<Widget> children = const <Widget>[],
    this.onPerformLayout,
  }) : super(
          key: key,
          children: children,
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
        );

  // ignore: lines_longer_than_80_chars
  final void Function(
          List<double> xOffsets, TextDirection textDirection, double width)
      onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context),
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    List<RenderBox> children,
    @required Axis direction,
    @required MainAxisSize mainAxisSize,
    @required MainAxisAlignment mainAxisAlignment,
    @required CrossAxisAlignment crossAxisAlignment,
    @required TextDirection textDirection,
    @required VerticalDirection verticalDirection,
    @required this.onPerformLayout,
  })  : assert(onPerformLayout != null),
        assert(textDirection != null),
        super(
          children: children,
          direction: direction,
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
        );

  void Function(List<double>, TextDirection, double) onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData = child.parentData as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
        break;
      case TextDirection.ltr:
        xOffsets.add(size.width);
        break;
    }
    onPerformLayout(xOffsets, textDirection, size.width);
  }
}

class _TabItemWidget extends AnimatedWidget {
  _TabItemWidget(
    this.tabBar, {
    Key key,
    this.tab,
    this.selected,
    Animation<double> animation,
    this.onPressed,
  }) : super(key: key, listenable: animation);

  final ColorfulTabBar tabBar;
  final TabItem tab;
  final bool selected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final padding = selected
        ? lerpDouble(tabBar.selectedTabPadding, tabBar.unselectedTabPadding,
                animation.value)
            .clamp(0.0, tabBar.tabHeight)
        : lerpDouble(tabBar.unselectedTabPadding, tabBar.selectedTabPadding,
                animation.value)
            .clamp(0.0, tabBar.tabHeight);

    final color = selected
        ? Color.lerp(
            tabBar.selectedColor, tabBar.unselectedColor, animation.value)
        : Color.lerp(
            tabBar.unselectedColor, tabBar.selectedColor, animation.value);
    return Padding(
      padding: selected
          ? EdgeInsets.fromLTRB(
              tabBar.verticalTabPadding, padding, tabBar.verticalTabPadding, 0)
          : EdgeInsets.fromLTRB(
              tabBar.verticalTabPadding, padding, tabBar.verticalTabPadding, 0),
      child: FlatButton(
          height: double.infinity,
          shape: tabBar.tabShape,
          color: tab.color,
          onPressed: onPressed,
          child: IconTheme(
            data: IconThemeData(color: color, size: 20),
            child: DefaultTextStyle(
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
                child: tab.title),
          )),
    );
  }
}

class _IndicatorWidget extends AnimatedWidget {
  const _IndicatorWidget({
    Key key,
    this.tabs,
    this.currentIndex,
    this.height,
    Animation<double> animation,
  }) : super(key: key, listenable: animation);

  final List<TabItem> tabs;
  final int currentIndex;
  final double height;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final value = (animation.value - currentIndex).clamp(-1.0, 1.0);
    Color color;
    if (value < 0) {
      if (currentIndex == 0) {
        color = tabs[currentIndex].color;
      } else {
        color = Color.lerp(
            tabs[currentIndex].color, tabs[currentIndex - 1].color, -value);
      }
    } else {
      if (currentIndex >= tabs.length - 1) {
        color = tabs[currentIndex].color;
      } else {
        color = Color.lerp(
            tabs[currentIndex].color, tabs[currentIndex + 1].color, value);
      }
    }
    return Container(
      color: color,
      width: double.infinity,
      height: height,
    );
  }
}

class _DragAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (parent != null) super.removeStatusListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (parent != null) super.removeListener(listener);
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue =
        controller.animation.value.clamp(0.0, controllerMaxValue) as double;
    return (controllerValue - index.toDouble()).abs().clamp(0.0, 1.0) as double;
  }
}

class _ChangeAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (parent != null) super.removeStatusListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (parent != null) super.removeListener(listener);
  }

  @override
  double get value => _indexChangeProgress(controller);

  double _indexChangeProgress(TabController controller) {
    final double controllerValue = controller.animation.value;
    final double previousIndex = controller.previousIndex.toDouble();
    final double currentIndex = controller.index.toDouble();

    // The controller's offset is changing because the user is dragging the
    // TabBarView's PageView to the left or right.
    if (!controller.indexIsChanging) {
      return (currentIndex - controllerValue).abs().clamp(0.0, 1.0) as double;
    }

    // The TabController animation's value is changing from
    // previousIndex to currentIndex.
    return (controllerValue - currentIndex).abs() /
        (currentIndex - previousIndex).abs();
  }
}
