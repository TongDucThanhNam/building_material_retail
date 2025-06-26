
import 'package:building_material_retail/domain/entities/product.dart';
import 'package:building_material_retail/domain/entities/product_variant.dart';

class CartItem {
  Product product;
  ProductVariant variantChosen;
  int quantity;

  CartItem(
      {required this.product,
      required this.quantity,
      required this.variantChosen});
}