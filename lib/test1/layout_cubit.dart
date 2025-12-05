import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/test1/resizable_item_data.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState()) {
    _initializeItems();
  }

  void _initializeItems() {
    final initialItems = <ResizableItemData>[
      ResizableItemData(
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
    emit(state.copyWith(items: initialItems));
  }

  void initializeItemSizes(double screenWidth) {
    // Chỉ khởi tạo một lần
    if (state.items.isNotEmpty && state.items.first.width != 200) return;

    const double paddingValue = 18.0;
    const double horizontalItemSpacing = 9.0;
    final smallItemWidth =
        (screenWidth - (paddingValue * 2) - horizontalItemSpacing) / 2;

    final updatedItems = state.items.map((item) {
      item.width = smallItemWidth;
      item.height = 250;
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  void reorderItems(int oldIndex, int newIndex) {
    final newItems = List<ResizableItemData>.from(state.items);
    final item = newItems.removeAt(oldIndex);
    newItems.insert(newIndex, item);
    emit(state.copyWith(items: newItems, forceNullDraggedItem: true));
  }

  void dragStarted(int index) {
    emit(state.copyWith(draggedItemIndex: index));
  }

  void dragEnded() {
    emit(state.copyWith(forceNullDraggedItem: true));
  }

  void updateItemSize(int index, {double? width, double? height}) {
    final newItems = List<ResizableItemData>.from(state.items);
    if (width != null) newItems[index].width = width;
    if (height != null) newItems[index].height = height;
    emit(state.copyWith(items: newItems));
  }

  void syncRowHeights(
    int itemIndex,
    double finalHeight,
    double largeItemWidth,
  ) {
    final newItems = List<ResizableItemData>.from(state.items);
    final ResizableItemData changedItem = newItems[itemIndex];

    // Corrected logic to build rows
    final List<List<ResizableItemData>> rows = [];
    int i = 0;
    while (i < newItems.length) {
      final currentItem = newItems[i];
      // Check if item is nearly the large item width to account for precision issues
      if (currentItem.width > largeItemWidth - 1) {
        rows.add([currentItem]);
        i++;
      } else {
        final newRow = [currentItem];
        if (i + 1 < newItems.length && newItems[i + 1].width < largeItemWidth -1) {
          newRow.add(newItems[i + 1]);
          i += 2;
        } else {
          i++;
        }
        rows.add(newRow);
      }
    }

    // Find the row containing the changed item and update all items in it
    for (final row in rows) {
      if (row.contains(changedItem)) {
        for (final itemInRow in row) {
          itemInRow.height = finalHeight;
        }
        break; // Exit after finding and updating the correct row
      }
    }

    emit(state.copyWith(items: newItems));
  }
}
