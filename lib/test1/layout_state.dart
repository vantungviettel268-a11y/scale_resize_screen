part of 'layout_cubit.dart';

class LayoutState extends Equatable {
  const LayoutState({this.items = const [], this.draggedItemIndex});

  final List<ResizableItemData> items;
  final int? draggedItemIndex;

  LayoutState copyWith({
    List<ResizableItemData>? items,
    int? draggedItemIndex,
    bool forceNullDraggedItem = false,
  }) {
    return LayoutState(
      items: items ?? this.items,
      draggedItemIndex: forceNullDraggedItem
          ? null
          : draggedItemIndex ?? this.draggedItemIndex,
    );
  }

  @override
  List<Object?> get props => [
    items,
    draggedItemIndex,
    // Dùng `map` để Equatable có thể so sánh list các object
    ...items.map((e) => e.hashCode).toList(),
  ];
}
