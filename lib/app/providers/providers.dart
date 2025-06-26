import 'package:building_material_retail/domain/entities/cart.dart';
import 'package:building_material_retail/domain/entities/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/product_service.dart';
import '../../services/supabase_storage_service.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

final authStateChangesProvider = StreamProvider((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

final databaseProvider = Provider<ProductService?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  final user = auth.asData?.value;
  if (user != null) {
    return ProductService(uid: user.id);
  }
  return null;
});

final addImageProvider = StateProvider<CroppedFile?>((ref) => null);

final storageProvider = Provider<SupabaseStorageService?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  final user = auth.asData?.value;
  if (user != null) {
    return SupabaseStorageService(uid: user.id);
  }
  return null;
});

//Search input Provider
final searchInputProvider = StateProvider<String>((_) => "");

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartItem>>((ref) {
  return CartNotifier();
});