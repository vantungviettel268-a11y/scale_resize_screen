import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout_state.dart';
import 'resizable_item_data.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState());

  void initializeItems(double initialSmallWidth, double initialHeight) {
    final items = List.generate(
      8,
      (index) => ResizableItemData(
        id: index,
        width: initialSmallWidth,
        height: initialHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              20,
              (i) => Text("Item ${index + 1} Line ${i + 1}"),
            ),
          ),
        ),
      ),
    );
    emit(state.copyWith(items: items));
  }

  void reorderItems(int oldIndex, int newIndex) {
    final newItems = List<ResizableItemData>.from(state.items);
    final item = newItems.removeAt(oldIndex);
    newItems.insert(newIndex, item);
    emit(state.copyWith(items: newItems, resetDraggedItem: true));
  }

  void startReorder(int index) {
    emit(state.copyWith(draggedItemIndex: index));
  }

  void cancelReorder() {
    emit(state.copyWith(resetDraggedItem: true));
  }

  void updateItemWidth(int index, double newWidth) {
    final newItems = List<ResizableItemData>.from(state.items);
    final item = newItems[index];
    newItems[index] = item.copyWith(width: newWidth);
    emit(state.copyWith(items: newItems));
  }
  
  void updateItemHeight(int index, double newHeight) {
    final newItems = List<ResizableItemData>.from(state.items);
    final item = newItems[index];
    newItems[index] = item.copyWith(height: newHeight);
    emit(state.copyWith(items: newItems));
  }

  void syncRowHeightsOnResizeEnd(int resizedItemIndex, double finalHeight, double largeItemWidth) {
    final List<List<ResizableItemData>> rows = [];
    final currentItems = state.items;
    int i = 0;
    while (i < currentItems.length) {
      final currentItem = currentItems[i];
      if (currentItem.width > largeItemWidth - 1) {
        rows.add([currentItem]);
        i++;
      } else {
        final newRow = [currentItem];
        if (i + 1 < currentItems.length && currentItems[i + 1].width < largeItemWidth - 1) {
          newRow.add(currentItems[i + 1]);
          i += 2;
        } else {
          i++;
        }
        rows.add(newRow);
      }
    }

    int? targetRowIndex;
    for (int j = 0; j < rows.length; j++) {
      if (rows[j].any((item) => item.id == currentItems[resizedItemIndex].id)) {
        targetRowIndex = j;
        break;
      }
    }

    if (targetRowIndex != null) {
      final newItems = List<ResizableItemData>.from(currentItems);
      final targetRow = rows[targetRowIndex];
      for (final itemToUpdate in targetRow) {
        final itemIndex = newItems.indexWhere((item) => item.id == itemToUpdate.id);
        if (itemIndex != -1) {
          newItems[itemIndex] = newItems[itemIndex].copyWith(height: finalHeight);
        }
      }
      emit(state.copyWith(items: newItems));
    }
  }
}
