import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/test1/layout_cubit.dart';
import 'package:flutter_application_1/test1/resizable_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

class LayoutEditorPage extends StatefulWidget {
  const LayoutEditorPage({super.key});

  @override
  State<LayoutEditorPage> createState() => _LayoutEditorPageState();
}

class _LayoutEditorPageState extends State<LayoutEditorPage> {
  bool _isInitialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialised) {
      final screenWidth = MediaQuery.of(context).size.width;
      context.read<LayoutCubit>().initializeItemSizes(screenWidth);
      _isInitialised = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double paddingValue = 18.0;
    const double horizontalItemSpacing = 9.0;
    const double verticalItemSpacing = horizontalItemSpacing * 2.1;
    final smallItemWidth =
        (screenWidth - (paddingValue * 2) - horizontalItemSpacing) / 2;
    final largeItemWidth = screenWidth - (paddingValue * 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Tùy chỉnh (Cubit)')),
      body: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final wrap = ReorderableWrap(
            spacing: horizontalItemSpacing,
            runSpacing: verticalItemSpacing,
            padding: const EdgeInsets.all(paddingValue),
            onReorder: context.read<LayoutCubit>().reorderItems,
            onNoReorder: (index) => context.read<LayoutCubit>().dragEnded(),
            onReorderStarted: (index) =>
                context.read<LayoutCubit>().dragStarted(index),
            children: state.items.asMap().entries.map((entry) {
              final int index = entry.key;
              final itemData = entry.value;

              final childWidget = ResizableWidget(
                key: ValueKey(itemData.hashCode),
                initialWidth: itemData.width,
                initialHeight: itemData.height,
                maxSize: largeItemWidth,
                smallItemWidth: smallItemWidth,
                largeItemWidth: largeItemWidth,
                onWidthChanged: (newWidth) {
                  context.read<LayoutCubit>().updateItemSize(
                    index,
                    width: newWidth,
                  );
                },
                onHeightChanged: (newHeight) {
                  context.read<LayoutCubit>().updateItemSize(
                    index,
                    height: newHeight,
                  );
                },
                onResizeEnd: (finalHeight) {
                  context.read<LayoutCubit>().syncRowHeights(
                    index,
                    finalHeight,
                    largeItemWidth,
                  );
                },
                child: itemData.child,
              );

              if (state.draggedItemIndex != null &&
                  state.draggedItemIndex != index) {
                return ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: childWidget,
                );
              }
              return childWidget;
            }).toList(),
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[wrap],
            ),
          );
        },
      ),
    );
  }
}
