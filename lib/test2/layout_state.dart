import 'package:equatable/equatable.dart';
import 'resizable_item_data.dart';

class LayoutState extends Equatable {
  final List<ResizableItemData> items;
  final int? draggedItemIndex;

  const LayoutState({
    this.items = const [],
    this.draggedItemIndex,
  });

  LayoutState copyWith({
    List<ResizableItemData>? items,
    int? draggedItemIndex,
    bool resetDraggedItem = false,
  }) {
    return LayoutState(
      items: items ?? this.items,
      draggedItemIndex: resetDraggedItem ? null : draggedItemIndex ?? this.draggedItemIndex,
    );
  }

  @override
  List<Object?> get props => [items, draggedItemIndex];
}
