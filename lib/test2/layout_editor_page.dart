import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'layout_cubit.dart';
import 'layout_state.dart';
import 'resizable_widget.dart';

class LayoutEditorPage extends StatefulWidget {
  final List<Widget>? children;

  const LayoutEditorPage({super.key, this.children});

  @override
  State<LayoutEditorPage> createState() => _LayoutEditorPageState();
}

class _LayoutEditorPageState extends State<LayoutEditorPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final screenWidth = MediaQuery.of(context).size.width;
      const double paddingValue = 18.0;
      const double horizontalItemSpacing = 9.0;
      final smallItemWidth =
          (screenWidth - (paddingValue * 2) - horizontalItemSpacing) / 2;
      const double initialHeight = 250.0;

      if (widget.children != null && widget.children!.isNotEmpty) {
        context.read<LayoutCubit>().loadLayout(
              widget.children!,
              smallItemWidth,
              initialHeight,
            );
      } else {
        context.read<LayoutCubit>().initializeItems(
              smallItemWidth,
              initialHeight,
            );
      }
      _initialized = true;
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
      appBar: AppBar(title: const Text('Layout Editor (Cubit)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<LayoutCubit>().saveLayout();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Layout saved!')),
          );
        },
        child: const Icon(Icons.save),
      ),
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
            onNoReorder: (index) => context.read<LayoutCubit>().cancelReorder(),
            onReorderStarted: (index) =>
                context.read<LayoutCubit>().startReorder(index),
            children: state.items.asMap().entries.map((entry) {
              final int index = entry.key;
              final itemData = entry.value;

              final childWidget = ResizableWidget(
                key: ValueKey(itemData.id),
                initialWidth: itemData.width,
                initialHeight: itemData.height,
                maxSize: largeItemWidth,
                smallItemWidth: smallItemWidth,
                largeItemWidth: largeItemWidth,
                onWidthChanged: (newWidth) {
                  context.read<LayoutCubit>().updateItemWidth(index, newWidth);
                },
                onHeightChanged: (newHeight) {
                  context.read<LayoutCubit>().updateItemHeight(
                        index,
                        newHeight,
                      );
                },
                onResizeEnd: (finalHeight) {
                  // Comment out to prevent auto-syncing heights
                  // context.read<LayoutCubit>().syncRowHeightsOnResizeEnd(
                  //   index,
                  //   finalHeight,
                  //   largeItemWidth,
                  // );
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
