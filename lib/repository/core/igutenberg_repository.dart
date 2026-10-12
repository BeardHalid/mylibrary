import 'package:mylibrary/models/marker_base.dart';
import 'package:mylibrary/repository/core/idata_source.dart';

abstract interface class IGutenbergRepository<T extends MarkerBase> implements IDataSource<T> {
  Future<List<T>?> search(String table, String filter, String query);
}
