import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';
import '../product_manage/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final WidgetRef ref;

  const ProductItem({super.key, required this.product, required this.ref});

  @override
  Widget build(BuildContext context) {
    String vietnameseCurrencyFormat(double price) {
      final priceStr = price.toStringAsFixed(0);
      return "${priceStr.replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}." )} VND";
    }

    final theme = Theme.of(context);
    // Colors
    const Color blue600 = Color(0xFF1E88E5); // blue-600
    const Color gray100 = Color(0xFFF5F5F5); // gray-100
    const Color gray800 = Color(0xFF424242); // gray-800
    const Color borderGray = Color(0xFFE0E0E0); // for border

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      focusColor: blue600.withOpacity(0.12),
      highlightColor: blue600.withOpacity(0.08),
      splashColor: blue600.withOpacity(0.10),
      child: Card(
        color: Colors.white,
        elevation: 8, // prominent shadow for depth
        shadowColor: blue600.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderGray, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder image (no imageUrl in new Product)
              Container(
                height: 88, // 44px min touch target
                width: 88,
                decoration: BoxDecoration(
                  color: gray100,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: borderGray, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: blue600.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 44, color: gray800),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: gray800,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Text(
                      "Giá: ${vietnameseCurrencyFormat(product.taxRate != null ? product.taxRate! : 0)}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: blue600,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Unit
                    Row(
                      children: [
                        Icon(Icons.straighten, size: 18, color: gray800.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        Text(
                          "Đơn vị tính: ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: gray800.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            product.unit ?? "-",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: gray800,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Category
                    Row(
                      children: [
                        Icon(Icons.category, size: 18, color: gray800.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        Text(
                          "Phân loại: ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: gray800.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            product.category ?? "-",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: gray800,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Tax Rate
                    Row(
                      children: [
                        Icon(Icons.percent, size: 18, color: gray800.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        Text(
                          "Thuế suất: ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: gray800.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${product.taxRate?.toString() ?? "0"}%",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: gray800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
