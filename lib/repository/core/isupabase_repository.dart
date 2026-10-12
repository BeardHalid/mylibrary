import 'package:mylibrary/models/marker_base.dart';
import 'package:mylibrary/repository/core/idata_source.dart';

abstract interface class ISupabaseRepository<T extends MarkerBase> implements IDataSource<T> {
  Future<T?> getById(String table, int id);
  Future<bool> set(String table, T ent, int id);
  Future<void> delete(String table, int id);
}
