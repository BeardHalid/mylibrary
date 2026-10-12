import 'dart:developer';

import 'package:mylibrary/models/marker_base.dart';
import 'package:mylibrary/repository/core/isupabase_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository<T extends MarkerBase> implements ISupabaseRepository<T> {
  final SupabaseClient _client;
  final T Function(Map<String, dynamic>) fromJson;

  SupabaseRepository({required this._client, required this.fromJson});

  @override
  Future<List<T>> getAll(String table) async {
    final maplist = await _client.from(table).select();
    final tList = maplist.map(fromJson).toList();
    return tList;
  }

  @override
  Future<bool> set(String table, T ent, int id) async {
    try {
      final t = await getById(table, id);
      if (t != null) {
        return false;
      } else {
        await _client.from(table).insert(ent.toJson());
        log('Kitap eklendi : $id');
        return true;
      }
    } catch (e) {
      throw Exception('Bir hata meydana geldi : $e');
    }
  }

  @override
  Future<void> delete(String table, int id) async {
    try {
      await _client.from(table).delete().eq('id', id);
      log('Kitap silindi : $id');
    } catch (e) {
      throw Exception('Delete from data failed => $table : $id');
    }
  }

  @override
  Future<T?> getById(String table, int id) async {
    T? ent;
    final x = await _client.from(table).select().eq('id', id).limit(1);
    if (x.isNotEmpty) {
      final t = x.map(fromJson).toList();
      ent = t.first;
    } else {
      ent = null;
    }
    return ent;
  }
}
