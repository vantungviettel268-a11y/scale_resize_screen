import 'package:flutter/material.dart';
import 'package:tendoo_components/theme/tendoo_styles.dart';
import 'package:tendoo_shared/tendoo_shared.dart' hide State;

class OrderStatusRatioWidget extends StatelessWidget {
  const OrderStatusRatioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.s, vertical: 4.s),
      decoration: BoxDecoration(
        color: Colour.white,
        borderRadius: BorderRadius.circular(8.s),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 12.s,
          right: 12.s,
          top: 12.s,
          bottom: 16.s,
        ),
        decoration: BoxDecoration(
          color: Colour.white,
          borderRadius: BorderRadius.circular(8.s),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final chartWidth = 120.s;
            final spacing = 16.s;
            final legendMinWidth = 100.s; // Chiều rộng tối thiểu cho legend
            final minRequiredWidth = chartWidth + spacing + legendMinWidth;
            final canShowLegend = constraints.maxWidth >= minRequiredWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TỶ LỆ ĐƠN THEO TRẠNG THÁI',
                  style: TendooStyles.t14Medium.copyWith(
                    color: Colour.neutral.base,
                  ),
                ),
                SizedBox(height: 16.s),
                if (canShowLegend)
                  Row(
                    children: [
                      // Circular chart placeholder
                      SizedBox(
                        width: chartWidth,
                        height: 140.s,
                        child: Image.asset('assets/images/img_chart.png'),
                      ),
                      SizedBox(width: spacing),
                      // Legend
                      SizedBox(
                        width: constraints.maxWidth - chartWidth - spacing,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendItem('Chờ xác nhận', Colors.yellow, 0),
                            SizedBox(height: 8.s),
                            _buildLegendItem('Đang xử lý', Colors.blue, 0),
                            SizedBox(height: 8.s),
                            _buildLegendItem('Hoàn thành', Colors.green, 0),
                            SizedBox(height: 8.s),
                            _buildLegendItem('Trả hàng', Colors.red, 0),
                            SizedBox(height: 8.s),
                            _buildLegendItem('Hủy', Colors.purple, 0),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // Chỉ hiển thị chart khi không đủ chỗ cho legend
                  Center(
                    child: SizedBox(
                        width: chartWidth,
                        height: 140.s,
                        child: Image.asset('assets/images/img_chart.png'),
                      ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 8.s,
          height: 8.s,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 8.s),
        Text(
          label,
          style: TendooStyles.t12Regular.copyWith(color: Colour.neutral.base),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Spacer(),
        SizedBox(width: 4.s),
        Text(
          '$count',
          style: TendooStyles.t12Regular.copyWith(color: Colour.neutral.base),
        ),
      ],
    );
  }
}
