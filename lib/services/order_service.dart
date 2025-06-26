import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/order.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<void> addOrder(Order order) async {
    try {
      await supabase.from('order').insert(order.toMap());
    } catch (e) {
      print('Error occurred while adding order: $e');
      rethrow;
    }
  }

  Stream<List<Order>> getOrders() async* {
    try {
      final List data = await supabase.from('order').select().order('created_at');
      yield data.map((d) => Order.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      yield [];
    }
  }

  Future<void> updateOrder(Order order) async {
    try {
      if (order.id == null) {
        throw ArgumentError('Order id cannot be null for update');
      }
      await supabase.from('order').update(order.toMap()).eq('id', order.id!);
    } catch (e) {
      print('Error updating order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await supabase.from('order').delete().eq('id', id);
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }
}
