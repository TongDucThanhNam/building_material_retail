import 'package:building_material_retail/models/product.dart';
import 'package:building_material_retail/models/variant.dart';

class CartItem {
  Product product;
  Variant variantChosen;
  int quantity;

  CartItem(
      {required this.product,
      required this.quantity,
      required this.variantChosen});
}
