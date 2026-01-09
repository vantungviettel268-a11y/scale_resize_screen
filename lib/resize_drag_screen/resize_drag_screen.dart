import 'package:flutter/material.dart';
import 'package:flutter_application_1/resize_drag_screen/widgets/bottom_button_confirm.dart';
import 'package:flutter_application_1/resize_drag_screen/widgets/order_status_ratio_widget.dart';
import 'package:flutter_application_1/resize_drag_screen/widgets/sales_revenue_widget.dart';
import 'package:tendoo_components/components/tendoo_app_bar.dart';
import 'package:tendoo_components/components/tendoo_background.dart';
import 'package:tendoo_components/components/tendoo_resize_drag_widget.dart';
import 'package:tendoo_components/components/tendoo_resize_drag_widget/widgets/layout_editor_page.dart';
import 'package:tendoo_shared/tendoo_shared.dart' hide State;

class ResizeDragScreen extends StatefulWidget {
  const ResizeDragScreen({super.key});

  @override
  State<ResizeDragScreen> createState() => _ResizeDragScreenState();
}

class _ResizeDragScreenState extends State<ResizeDragScreen> {
  final GlobalKey<LayoutEditorPageState> _layoutEditorKey =
      GlobalKey<LayoutEditorPageState>();
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      scaffoldBuilder: () {
        return TendooBackground(
          child: BaseScaffold(
            configs: BaseScaffoldConfigs(
              appBar: const TendooAppBar(title: 'Tuỳ chỉnh'),
              body: Column(
                children: [
                  Expanded(
                    child: TendooResizeDragWidget(
                      layoutEditorKey: _layoutEditorKey,
                      children: [
                        const SalesRevenueWidget(),
                        const OrderStatusRatioWidget(),
                      ],
                      onItemRemoved: (value) {},
                    ),
                  ),
                  BottomButton(
                    callBackConfirm: () {
                      _layoutEditorKey.currentState?.saveLayout();
                    },
                    isConfirmLoading: false,
                    isDisableConfirm: false,
                    titleConfirm: 'Lưu',
                    callBackCancel: () {
                      Navigator.of(context).pop();
                    },
                    titleCancel: 'Hủy',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
