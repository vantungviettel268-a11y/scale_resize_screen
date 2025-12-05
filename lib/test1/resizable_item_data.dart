import 'package:flutter/material.dart';

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
