import 'package:mylibrary/models/marker_base.dart';
import 'package:mylibrary/repository/impl/gutenberg_repository.dart';
import 'package:mylibrary/repository/impl/supabase_repository.dart';

abstract interface class IBaseRepository {
  SupabaseRepository<T> supabase<T extends MarkerBase>({
    required T Function(Map<String, dynamic>) fromJson,
  });

  GutenbergRepository<T> gutenberg<T extends MarkerBase>({
    required T Function(Map<String, dynamic>) fromJson,
  });
}
