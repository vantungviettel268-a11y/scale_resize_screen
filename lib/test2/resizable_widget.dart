import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResizableWidget extends StatefulWidget {
  final Widget child;
  final double minSize;
  final double maxSize;
  final double initialWidth;
  final double initialHeight;
  final ValueChanged<double>? onWidthChanged;
  final double smallItemWidth;
  final double largeItemWidth;
  final ValueChanged<double>? onHeightChanged;
  final ValueChanged<double>? onResizeEnd;
  final ValueChanged<bool>? onResizeStateChanged;

  const ResizableWidget({
    super.key,
    required this.child,
    this.minSize = 100,
    this.maxSize = 400,
    this.initialWidth = 200,
    this.initialHeight = 200,
    this.onWidthChanged,
    this.onHeightChanged,
    required this.smallItemWidth,
    this.onResizeEnd,
    required this.largeItemWidth,
    this.onResizeStateChanged,
  });

  @override
  State<ResizableWidget> createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget>
    with SingleTickerProviderStateMixin {
  late double _width;
  late double _height;
  late AnimationController _controller;
  bool _isResizing = false;
  Offset? _lastPanPosition;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ResizableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update width if it significantly changed (not from height resize)
    if ((widget.initialWidth - _width).abs() > 1) {
      _width = widget.initialWidth;
    }

    // Only animate height if it changed from outside (not from user drag)
    if (widget.initialHeight != oldWidget.initialHeight &&
        (widget.initialHeight - _height).abs() > 1 &&
        !_controller.isAnimating) {
      final heightAnimation = Tween<double>(
        begin: _height,
        end: widget.initialHeight,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      heightAnimation.addListener(() {
        setState(() {
          _height = heightAnimation.value;
        });
      });
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Chặn scroll khi đang resize
        return _isResizing;
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey, width: 0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(child: widget.child),
            ),
            Positioned(
              top: -10,
              left: -10,
              child: SvgPicture.asset('assets/images/icon_remove.svg'),
            ),
            Positioned(
              bottom: -34,
              right: -34,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  _isResizing = true;
                  _lastPanPosition = event.position;
                  _controller.stop();
                  widget.onResizeStateChanged?.call(true);
                },
                onPointerMove: (event) {
                  if (_isResizing && _lastPanPosition != null) {
                    final delta = event.position - _lastPanPosition!;
                    setState(() {
                      _width = (_width + delta.dx).clamp(
                        widget.minSize,
                        widget.maxSize,
                      );
                      _height = (_height + delta.dy).clamp(
                        widget.minSize,
                        double.infinity,
                      );
                      widget.onWidthChanged?.call(_width);
                      widget.onHeightChanged?.call(_height);
                    });
                    _lastPanPosition = event.position;
                  }
                },
                onPointerUp: (event) {
                  if (_isResizing) {
                    _isResizing = false;
                    _lastPanPosition = null;
                    widget.onResizeStateChanged?.call(false);

                    final threshold =
                        (widget.smallItemWidth + widget.largeItemWidth) / 2;
                    final targetWidth = _width > threshold
                        ? widget.largeItemWidth
                        : widget.smallItemWidth;

                    final widthAnimation =
                        Tween<double>(begin: _width, end: targetWidth).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeOut,
                          ),
                        );

                    AnimationStatusListener? statusListener;
                    widthAnimation.addListener(() {
                      setState(() {
                        _width = widthAnimation.value;
                        widget.onWidthChanged?.call(_width);
                      });
                    });

                    statusListener = (status) {
                      if (status == AnimationStatus.completed) {
                        widget.onResizeEnd?.call(_height);
                        _controller.removeStatusListener(statusListener!);
                      }
                    };
                    _controller.addStatusListener(statusListener);

                    _controller.forward(from: 0);
                  }
                },
                onPointerCancel: (event) {
                  _isResizing = false;
                  _lastPanPosition = null;
                  widget.onResizeStateChanged?.call(false);
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {}, // Empty handler to prevent tap events
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: SvgPicture.asset(
                        'assets/images/icon_rectangle.svg',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
