import 'package:flutter/material.dart';
import 'package:tendoo_components/theme/tendoo_styles.dart';
import 'package:tendoo_shared/tendoo_shared.dart' hide State;

class SalesRevenueWidget extends StatelessWidget {
  const SalesRevenueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.s, vertical: 4.s),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DOANH THU BÁN HÀNG',
              style: TendooStyles.t14Medium.copyWith(
                color: Colour.neutral.base,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 12.s),
            _buildRevenueItem('Tổng giá bán', '0đ'),
            SizedBox(height: 8.s),
            _buildRevenueItem('Giảm giá', '0đ'),
            SizedBox(height: 8.s),
            _buildRevenueItem('Trừ tích điểm', '0đ'),
            SizedBox(height: 8.s),
            _buildRevenueItem('Hoàn trả', '0đ'),
            SizedBox(height: 8.s),
            _buildRevenueItem('Phụ thu', '0đ'),
            SizedBox(height: 8.s),
            _buildRevenueItem('Thu phí vận chuyển', '0đ'),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TendooStyles.t14Regular.copyWith(color: Colour.neutral.base),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(width: 8.s),
        Text(
          value,
          style: TendooStyles.t14Regular.copyWith(color: Colour.neutral.base),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
