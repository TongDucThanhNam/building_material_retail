import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/customer.dart';

class CustomerService {
  final supabase = Supabase.instance.client;

  Future<void> addCustomer(Customer customer) async {
    try {
      await supabase.from('customer').insert(customer.toMap());
    } catch (e) {
      print('Error occurred while adding customer: $e');
      rethrow;
    }
  }

  Stream<List<Customer>> getCustomers() async* {
    try {
      final List data = await supabase.from('customer').select().order('name');
      yield data.map((d) => Customer.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting customers: $e');
      yield [];
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    if (customer.id == null) {
      throw ArgumentError('Customer id cannot be null for update');
    }
    try {
      await supabase.from('customer').update(customer.toMap()).eq('id', customer.id!);
    } catch (e) {
      print('Error updating customer: $e');
      rethrow;
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await supabase.from('customer').delete().eq('id', id);
    } catch (e) {
      print('Error deleting customer: $e');
      rethrow;
    }
  }
}
