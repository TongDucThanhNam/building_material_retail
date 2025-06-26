import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/quotation_detail.dart';

class QuotationDetailService {
  final supabase = Supabase.instance.client;

  Future<void> addQuotationDetail(QuotationDetail detail) async {
    try {
      await supabase.from('quotation_detail').insert(detail.toMap());
    } catch (e) {
      print('Error occurred while adding quotation detail: $e');
      rethrow;
    }
  }

  Stream<List<QuotationDetail>> getQuotationDetails() async* {
    try {
      final List data = await supabase.from('quotation_detail').select().order('id');
      yield data.map((d) => QuotationDetail.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting quotation details: $e');
      yield [];
    }
  }

  Future<void> updateQuotationDetail(QuotationDetail detail) async {
    try {
      if (detail.id == null) {
        throw ArgumentError('QuotationDetail id cannot be null for update');
      }
      await supabase.from('quotation_detail').update(detail.toMap()).eq('id', detail.id!);
    } catch (e) {
      print('Error updating quotation detail: $e');
      rethrow;
    }
  }

  Future<void> deleteQuotationDetail(String id) async {
    try {
      await supabase.from('quotation_detail').delete().eq('id', id);
    } catch (e) {
      print('Error deleting quotation detail: $e');
      rethrow;
    }
  }
}
