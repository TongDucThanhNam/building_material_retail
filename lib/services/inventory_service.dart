import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/inventory.dart';

class InventoryService {
  final supabase = Supabase.instance.client;

  Future<void> addInventory(Inventory inventory) async {
    try {
      await supabase.from('inventory').insert(inventory.toMap());
    } catch (e) {
      print('Error occurred while adding inventory: $e');
      rethrow;
    }
  }

  Stream<List<Inventory>> getInventories() async* {
    try {
      final List data = await supabase.from('inventory').select().order('id');
      yield data.map((d) => Inventory.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting inventories: $e');
      yield [];
    }
  }

  Future<void> updateInventory(Inventory inventory) async {
    try {
      if (inventory.id == null) {
        throw ArgumentError('Inventory id cannot be null for update');
      }
      await supabase.from('inventory').update(inventory.toMap()).eq('id', inventory.id!);
    } catch (e) {
      print('Error updating inventory: $e');
      rethrow;
    }
  }

  Future<void> deleteInventory(String id) async {
    try {
      await supabase.from('inventory').delete().eq('id', id);
    } catch (e) {
      print('Error deleting inventory: $e');
      rethrow;
    }
  }
}
