import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/quotation.dart';

class QuotationService {
  final supabase = Supabase.instance.client;

  Future<void> addQuotation(Quotation quotation) async {
    try {
      await supabase.from('quotation').insert(quotation.toMap());
    } catch (e) {
      print('Error occurred while adding quotation: $e');
      rethrow;
    }
  }

  Stream<List<Quotation>> getQuotations() async* {
    try {
      final List data = await supabase.from('quotation').select().order('valid_from');
      yield data.map((d) => Quotation.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting quotations: $e');
      yield [];
    }
  }

  Future<void> updateQuotation(Quotation quotation) async {
    try {
      if (quotation.id == null) {
        throw ArgumentError('Quotation id cannot be null for update');
      }
      await supabase.from('quotation').update(quotation.toMap()).eq('id', quotation.id!);
    } catch (e) {
      print('Error updating quotation: $e');
      rethrow;
    }
  }

  Future<void> deleteQuotation(String id) async {
    try {
      await supabase.from('quotation').delete().eq('id', id);
    } catch (e) {
      print('Error deleting quotation: $e');
      rethrow;
    }
  }
}
