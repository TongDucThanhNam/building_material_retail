import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/user.dart' as entity;

class UserService {
  final supabase = Supabase.instance.client;

  Future<void> addUser(entity.User user) async {
    try {
      await supabase.from('user').insert(user.toMap());
    } catch (e) {
      print('Error occurred while adding user: $e');
      rethrow;
    }
  }

  Stream<List<entity.User>> getUsers() async* {
    try {
      final List data = await supabase.from('user').select().order('username');
      yield data.map((d) => entity.User.fromMap(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting users: $e');
      yield [];
    }
  }

  Future<void> updateUser(entity.User user) async {
    try {
      if (user.id == null) {
        throw ArgumentError('User id cannot be null for update');
      }
      await supabase.from('user').update(user.toMap()).eq('id', user.id!);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await supabase.from('user').delete().eq('id', id);
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}
