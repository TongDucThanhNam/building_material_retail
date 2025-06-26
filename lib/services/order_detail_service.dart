import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/order_detail.dart';

class OrderDetailService {
  final supabase = Supabase.instance.client;

  Future<void> addOrderDetail(OrderDetail detail) async {
    try {
      await supabase.from('order_detail').insert(detail.toMap());
    } catch (e) {
      print('Error occurred while adding order detail: $e');
      rethrow;
    }
  }

  Stream<List<OrderDetail>> getOrderDetails() async* {
    try {
      final List data = await supabase.from('order_detail').select().order('id');
      yield data.map((d) => OrderDetail.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting order details: $e');
      yield [];
    }
  }

  Future<void> updateOrderDetail(OrderDetail detail) async {
    try {
      if (detail.id == null) {
        throw ArgumentError('OrderDetail id cannot be null for update');
      }
      await supabase.from('order_detail').update(detail.toMap()).eq('id', detail.id!);
    } catch (e) {
      print('Error updating order detail: $e');
      rethrow;
    }
  }

  Future<void> deleteOrderDetail(String id) async {
    try {
      await supabase.from('order_detail').delete().eq('id', id);
    } catch (e) {
      print('Error deleting order detail: $e');
      rethrow;
    }
  }
}
