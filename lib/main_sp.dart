import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reorderables/reorderables.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<ResizableItemData> _itemDataList;
  bool _initialWidthsSet =
      false; // Cờ để đảm bảo chiều rộng ban đầu chỉ được đặt một lần
  int? _draggedItemIndex; // Biến để theo dõi item đang được kéo

  @override
  void initState() {
    super.initState();
    _itemDataList = <ResizableItemData>[
      ResizableItemData(
        // Thêm nội dung dài để minh họa cho việc cuộn
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              20,
              (index) =>
                  Text("Đây là dòng nội dung thứ ${index + 1} có thể cuộn."),
            ),
          ),
        ),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 2")),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 3")),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 4")),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 5")),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 6")),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 7")),
      ),
      ResizableItemData(
        child: const Center(child: Text("Kéo để thay đổi size 8")),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double paddingValue = 18.0;
    const double horizontalItemSpacing = 9.0;
    const double verticalItemSpacing =
        horizontalItemSpacing * 2.1; // Lớn hơn gấp đôi
    final smallItemWidth =
        (screenWidth - (paddingValue * 2) - horizontalItemSpacing) / 2;
    final largeItemWidth = screenWidth - (paddingValue * 2);

    // Đặt chiều rộng ban đầu cho các item nếu chưa được đặt
    if (!_initialWidthsSet) {
      for (var item in _itemDataList) {
        item.width = smallItemWidth;
        item.height = 250; // Tăng chiều cao mặc định
      }
      _initialWidthsSet = true;
    }

    void onReorder(int oldIndex, int newIndex) {
      setState(() {
        // Kết thúc kéo, reset lại index
        _draggedItemIndex = null;
        ResizableItemData item = _itemDataList.removeAt(oldIndex);
        _itemDataList.insert(newIndex, item);
      });
    }

    var wrap = ReorderableWrap(
      spacing: horizontalItemSpacing,
      runSpacing: verticalItemSpacing,
      padding: const EdgeInsets.all(
        paddingValue,
      ), // Áp dụng padding cho cả 4 phía
      onReorder: onReorder,
      onNoReorder: (int index) {
        // Callback này được gọi khi kéo nhưng không đổi vị trí
        setState(() {
          _draggedItemIndex = null;
        });
        debugPrint(
          '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index',
        );
      },
      onReorderStarted: (int index) {
        // Callback này được gọi khi bắt đầu kéo
        setState(() {
          _draggedItemIndex = index;
        });
        debugPrint(
          '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index',
        );
      },
      children: _itemDataList.asMap().entries.map((entry) {
        final int index = entry.key;
        final ResizableItemData itemData = entry.value;

        final childWidget = ResizableWidget(
          key: ValueKey(itemData.hashCode),
          initialWidth: itemData.width,
          initialHeight: itemData.height,
          maxSize:
              largeItemWidth, // Đặt kích thước tối đa là chiều rộng màn hình
          smallItemWidth: smallItemWidth,
          largeItemWidth: largeItemWidth,
          onWidthChanged: (newWidth) {
            setState(() {
              itemData.width = newWidth;
            });
          },
          onHeightChanged: (newHeight) {
            // Khi đang kéo, chỉ cập nhật chiều cao cho item hiện tại
            setState(() {
              itemData.height = newHeight;
            });
          },
          onResizeEnd: (finalHeight) {
            // Khi kéo xong, đồng bộ chiều cao cho các item cùng hàng
            final List<List<ResizableItemData>> rows = [];
            int i = 0;
            while (i < _itemDataList.length) {
              final currentItem = _itemDataList[i];
              if (currentItem.width == largeItemWidth) {
                rows.add([currentItem]);
                i++;
              } else {
                final newRow = [currentItem];
                if (i + 1 < _itemDataList.length &&
                    _itemDataList[i + 1].width != largeItemWidth) {
                  newRow.add(_itemDataList[i + 1]);
                  i += 2;
                } else {
                  i++;
                }
                rows.add(newRow);
              }
            }

            for (final row in rows) {
              if (row.contains(itemData)) {
                setState(() {
                  for (final itemInRow in row) {
                    itemInRow.height = finalHeight;
                  }
                });
                break;
              }
            }
          },
          child: itemData.child,
        );

        // Nếu đang kéo và item này không phải là item được kéo, làm mờ nó đi
        if (_draggedItemIndex != null && _draggedItemIndex != index) {
          return ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: childWidget,
          );
        }
        return childWidget;
      }).toList(),
    );

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[wrap],
    );

    return Scaffold(
      appBar: AppBar(title: Text('Tùy chỉnh')),
      body: SingleChildScrollView(child: column),
    );
  }
}

// Lớp dữ liệu để lưu trữ trạng thái của mỗi ResizableWidget
class ResizableItemData {
  final Widget child;
  double width;
  double height;

  ResizableItemData({
    required this.child,
    this.width = 200, // Giá trị mặc định, sẽ được ghi đè
    this.height = 200, // Giá trị mặc định, sẽ được ghi đè
  });
}

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
            bottom: -14,
            right: -14,
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
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset('assets/images/icon_rectangle.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
