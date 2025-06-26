import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/invoice.dart';

class InvoiceService {
  final supabase = Supabase.instance.client;

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await supabase.from('invoice').insert(invoice.toMap());
    } catch (e) {
      print('Error occurred while adding invoice: $e');
      rethrow;
    }
  }

  Stream<List<Invoice>> getInvoices() async* {
    try {
      final List data = await supabase.from('invoice').select().order('issue_date');
      yield data.map((d) => Invoice.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting invoices: $e');
      yield [];
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      if (invoice.id == null) {
        throw ArgumentError('Invoice id cannot be null for update');
      }
      await supabase.from('invoice').update(invoice.toMap()).eq('id', invoice.id!);
    } catch (e) {
      print('Error updating invoice: $e');
      rethrow;
    }
  }

  Future<void> deleteInvoice(String id) async {
    try {
      await supabase.from('invoice').delete().eq('id', id);
    } catch (e) {
      print('Error deleting invoice: $e');
      rethrow;
    }
  }
}
