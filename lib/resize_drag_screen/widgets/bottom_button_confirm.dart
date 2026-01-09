import 'package:flutter/material.dart';
import 'package:tendoo_components/components/export.dart';

class BottomButton extends StatelessWidget {
  final String titleConfirm;
  final String titleCancel;
  final VoidCallback callBackConfirm;
  final VoidCallback callBackCancel;
  final bool isDisableConfirm;
  final bool isConfirmLoading;
  const BottomButton({
    super.key,
    required this.callBackConfirm,
    required this.callBackCancel,
    required this.titleConfirm,
    required this.titleCancel,
    required this.isDisableConfirm,
    required this.isConfirmLoading,
  });

  @override
  Widget build(BuildContext context) {
    TendooButtonState tendooButtonState = TendooButtonState.active;

    if (isConfirmLoading) {
      tendooButtonState = TendooButtonState.loading;
    } else if (isDisableConfirm) {
      tendooButtonState = TendooButtonState.inactive;
    }
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TendooButton.outline(
                    text: titleCancel,
                    onPressed: () => callBackCancel(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TendooButton.primary(
                    text: titleConfirm,
                    onPressed: () => callBackConfirm(),
                    state: tendooButtonState,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
