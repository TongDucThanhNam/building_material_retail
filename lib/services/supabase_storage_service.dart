import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  SupabaseStorageService({required this.uid});

  final String uid;
  final supabase = Supabase.instance.client;

  Future<String> uploadFile(String filePath) async {
    try {
      final dateTime = DateTime.now().toIso8601String();
      final file = File(filePath);
      final fileName = "$uid/$dateTime";
      final response = await supabase.storage.from('product-images').upload(fileName, file);
      if (response.isNotEmpty) {
        final url = supabase.storage.from('product-images').getPublicUrl(fileName);
        return url;
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
    return "";
  }
}
