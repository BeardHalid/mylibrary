import 'package:dio/dio.dart';
import 'package:mylibrary/models/marker_base.dart';
import 'package:mylibrary/repository/core/ibase_repository.dart';
import 'package:mylibrary/repository/impl/gutenberg_repository.dart';
import 'package:mylibrary/repository/impl/supabase_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BaseRepository implements IBaseRepository {
  final SupabaseClient client;
  final Dio dio;

  BaseRepository({required this.client, required this.dio});

  @override
  GutenbergRepository<T> gutenberg<T extends MarkerBase>({
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    return GutenbergRepository<T>(client: dio, fromJson: fromJson);
  }

  @override
  SupabaseRepository<T> supabase<T extends MarkerBase>({
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    return SupabaseRepository<T>(client: client, fromJson: fromJson);
  }
}
