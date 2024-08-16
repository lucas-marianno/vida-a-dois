import 'package:flutter/material.dart';

enum _ScrollDirection {
  right,
  left;

  /// [right] = `1`
  /// [left] = `-1`
  int get asValue => this == right ? 1 : -1;
}

/// [DraggableScrollController] triggers animations in a [ScrollController]
/// based on the global  position `OffSet` of a draggable object
///
/// Example:
///
/// ``` dart
/// // instantiate the controller
/// DraggableScrollController controller = DraggableScrollController(
///   context,
///   horizontalScrollController: horizontalScrollController,
/// );
///
/// // use it in a draggable object
/// LongPressDraggable(
///   onDragUpdate: controller.onDragUpdate,
///   feedback: Material(
///     color: Colors.transparent,
///     borderRadius: BorderRadius.circular(20),
///     elevation: 6,
///     child: const Text('being dragged'),
///   ),
///   childWhenDragging: const Text('left behind'),
///   child: const Text('child'),
/// );
///
/// ```
class DraggableScrollController {
  final BuildContext context;
  final ScrollController horizontalScrollController;
  final Duration interval;
  final double acceleration;
  final double triggerAreaScreenRatio;
  final double initialScrollAmount;

  DraggableScrollController(
    this.context, {
    required this.horizontalScrollController,
    this.interval = const Duration(milliseconds: 100),
    this.acceleration = 1.5,
    this.triggerAreaScreenRatio = 0.1,
    this.initialScrollAmount = 30,
  })  : assert(interval != Duration.zero),
        assert(!interval.isNegative),
        assert(acceleration >= 0),
        assert(triggerAreaScreenRatio > 0 && triggerAreaScreenRatio < 1),
        assert(initialScrollAmount >= 1);

  void onDragUpdate(DragUpdateDetails details) {
    _checkEdgeAreaEnter(details.globalPosition);
  }

  // private
  bool _wasOnTriggerArea = false;

  void _checkEdgeAreaEnter(Offset draggableGlobalPosition) {
    final width = MediaQuery.of(context).size.width;
    final triggerAreaSize = width * triggerAreaScreenRatio;
    final pos = draggableGlobalPosition.dx;

    final isOnLeftTriggerArea = pos < 0 + triggerAreaSize;
    final isOnRightTriggerArea = pos > width - triggerAreaSize;
    final isNotOnTriggerArea = (!isOnRightTriggerArea && !isOnLeftTriggerArea);

    if (!_wasOnTriggerArea && isNotOnTriggerArea) return;

    if (!_wasOnTriggerArea) {
      if (isNotOnTriggerArea) return;

      _wasOnTriggerArea = true;

      if (isOnRightTriggerArea) _startScrollingPage(_ScrollDirection.right);
      if (isOnLeftTriggerArea) _startScrollingPage(_ScrollDirection.left);
    } else {
      if (isNotOnTriggerArea) _wasOnTriggerArea = false;
    }
  }

  void _startScrollingPage(_ScrollDirection direction) async {
    final ScrollController horzCtrl = horizontalScrollController;
    final double maxScroll = horzCtrl.position.maxScrollExtent;

    double scrollAmount = initialScrollAmount * direction.asValue;

    while (_wasOnTriggerArea) {
      await Future.wait([
        horzCtrl.animateTo(
          (horzCtrl.offset + scrollAmount).clamp(0, maxScroll),
          duration: interval,
          curve: Curves.linear,
        ),
        Future.delayed(interval),
      ]);

      if (horzCtrl.position.atEdge) break;

      scrollAmount *= acceleration;
    }
  }
}
