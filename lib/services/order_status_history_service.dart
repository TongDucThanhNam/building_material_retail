import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/order_status_history.dart';

class OrderStatusHistoryService {
  final supabase = Supabase.instance.client;

  Future<void> addOrderStatusHistory(OrderStatusHistory history) async {
    try {
      await supabase.from('order_status_history').insert(history.toMap());
    } catch (e) {
      print('Error occurred while adding order status history: $e');
      rethrow;
    }
  }

  Stream<List<OrderStatusHistory>> getOrderStatusHistories() async* {
    try {
      final List data = await supabase.from('order_status_history').select().order('changed_at');
      yield data.map((d) => OrderStatusHistory.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting order status histories: $e');
      yield [];
    }
  }

  Future<void> updateOrderStatusHistory(OrderStatusHistory history) async {
    try {
      if (history.id == null) {
        throw ArgumentError('OrderStatusHistory id cannot be null for update');
      }
      await supabase.from('order_status_history').update(history.toMap()).eq('id', history.id!);
    } catch (e) {
      print('Error updating order status history: $e');
      rethrow;
    }
  }

  Future<void> deleteOrderStatusHistory(String id) async {
    try {
      await supabase.from('order_status_history').delete().eq('id', id);
    } catch (e) {
      print('Error deleting order status history: $e');
      rethrow;
    }
  }
}
