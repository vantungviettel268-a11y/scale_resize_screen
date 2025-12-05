import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResizableWidget extends StatefulWidget {
  final Widget child;
  final double minSize;
  final double maxSize;
  final double initialWidth; // Chiều rộng ban đầu
  final double initialHeight; // Chiều cao ban đầu
  final ValueChanged<double>?
  onWidthChanged; // Callback khi chiều rộng thay đổi
  final double smallItemWidth;
  final double largeItemWidth;
  final ValueChanged<double>?
  onHeightChanged; // Callback khi chiều cao thay đổi
  final ValueChanged<double>? onResizeEnd; // Callback khi kéo xong

  const ResizableWidget({
    super.key,
    required this.child,
    this.minSize = 100,
    this.maxSize = 400, // Giá trị mặc định, sẽ được ghi đè từ MyHomePage
    this.initialWidth = 200,
    this.initialHeight = 200,
    this.onWidthChanged,
    this.onHeightChanged,
    required this.smallItemWidth,
    this.onResizeEnd,
    required this.largeItemWidth,
  });

  @override
  State<ResizableWidget> createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget>
    with SingleTickerProviderStateMixin {
  late double _width; // Khởi tạo từ widget.initialWidth
  late double _height; // Khởi tạo từ widget.initialHeight
  late AnimationController _controller;

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
    // Luôn cập nhật chiều rộng ngay lập tức
    _width = widget.initialWidth;

    // Nếu chiều cao được cập nhật từ widget cha, hãy tạo animation
    if (widget.initialHeight != oldWidget.initialHeight &&
        widget.initialHeight != _height) {
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
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nội dung chính
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

          // Nút kéo resize
          Positioned(
            bottom: -24,
            right: -24,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                _controller.stop(); // Dừng animation nếu đang kéo
              },
              onPanUpdate: (details) {
                setState(() {
                  // Cập nhật chiều rộng
                  _width = (_width + details.delta.dx).clamp(
                    widget.minSize,
                    widget.maxSize,
                  );
                  // Cập nhật chiều cao
                  _height = (_height + details.delta.dy).clamp(
                    widget.minSize,
                    double.infinity,
                  );
                  widget.onWidthChanged?.call(_width);
                  widget.onHeightChanged?.call(_height);
                });
              },
              onPanEnd: (details) {
                final threshold =
                    (widget.smallItemWidth + widget.largeItemWidth) / 2;
                final targetWidth = _width > threshold
                    ? widget.largeItemWidth
                    : widget.smallItemWidth;

                final animation = Tween<double>(begin: _width, end: targetWidth)
                    .animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOut,
                      ),
                    );

                animation.addListener(() {
                  setState(() {
                    _width = animation.value;
                    widget.onWidthChanged?.call(
                      _width,
                    ); // Thông báo cho widget cha sau mỗi bước animation
                  });
                });

                _controller.addStatusListener((status) {
                  if (status == AnimationStatus.completed) {
                    // Gọi callback onResizeEnd CHỈ KHI animation kết thúc.
                    // Điều này đảm bảo logic đồng bộ chiều cao được thực thi
                    // với trạng thái width cuối cùng.
                    widget.onResizeEnd?.call(_height);
                  }
                });
                _controller.forward(from: 0);
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SvgPicture.asset('assets/images/icon_rectangle.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
