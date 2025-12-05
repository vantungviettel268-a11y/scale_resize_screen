import 'package:flutter/material.dart';

@immutable
class ResizableItemData {
  final Widget child;
  final double width;
  final double height;
  final int id;

  const ResizableItemData({
    required this.child,
    required this.width,
    required this.height,
    required this.id,
  });

  ResizableItemData copyWith({
    Widget? child,
    double? width,
    double? height,
  }) {
    return ResizableItemData(
      child: child ?? this.child,
      width: width ?? this.width,
      height: height ?? this.height,
      id: id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResizableItemData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => Object.hash(id, width, height);
}
