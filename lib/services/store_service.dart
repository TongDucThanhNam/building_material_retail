import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/store.dart';

class StoreService {
  final supabase = Supabase.instance.client;

  Future<void> addStore(Store store) async {
    try {
      await supabase.from('store').insert(store.toMap());
    } catch (e) {
      print('Error occurred while adding store: $e');
      rethrow;
    }
  }

  Stream<List<Store>> getStores() async* {
    try {
      final List data = await supabase.from('store').select().order('name');
      yield data.map((d) => Store.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting stores: $e');
      yield [];
    }
  }

  Future<void> updateStore(Store store) async {
    try {
      if (store.id == null) {
        throw ArgumentError('Store id cannot be null for update');
      }
      await supabase.from('store').update(store.toMap()).eq('id', store.id!);
    } catch (e) {
      print('Error updating store: $e');
      rethrow;
    }
  }

  Future<void> deleteStore(String id) async {
    try {
      await supabase.from('store').delete().eq('id', id);
    } catch (e) {
      print('Error deleting store: $e');
      rethrow;
    }
  }
}
