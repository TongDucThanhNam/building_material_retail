import 'package:building_material_retail/domain/entities/cart_item.dart';
import 'package:building_material_retail/domain/entities/product.dart';
import 'package:building_material_retail/domain/entities/product_variant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super({});

  Map<String, CartItem> get items => state;

  int get itemCount => state.length;

  double get totalAmount {
    double total = 0;
    state.forEach((key, cartItem) {
      total += ((cartItem.variantChosen.basePrice) * cartItem.quantity);
    });
    return total;
  }

  void addItem(String id, Product product, ProductVariant variantChosen) {
    if (state.containsKey(id)) {
      //Update State
      state = {
        ...state,
        id: CartItem(
            product: product,
            variantChosen: variantChosen,
            quantity: state[id]!.quantity + 1)
      };
    } else {
      //Add new CartItem
      state = {
        ...state,
        id: CartItem(
            product: product, quantity: 1, variantChosen: variantChosen)
      };
    }
  }

  void removeItem(String id) {
    // Kiểm tra xem item có trong giỏ hàng không
    if (state.containsKey(id)) {
      // Nếu số lượng lớn hơn 1, giảm số lượng
      if (state[id]!.quantity > 1) {
        // Giảm số lượng và cập nhật state
        state = {
          ...state,
          id: CartItem(
            product: state[id]!.product,
            variantChosen: state[id]!.variantChosen,
            quantity: state[id]!.quantity - 1, // Giảm số lượng
          ),
        };
      } else {
        // Nếu số lượng bằng 1, xóa item khỏi giỏ hàng
        state = {
          ...state,
        }..remove(id); // Xóa item khỏi giỏ hàng
      }
    }
  }

  void clear() {
    state = {};
  }
}