import 'package:mylibrary/models/marker_base.dart';

abstract interface class IDataSource<T extends MarkerBase> {
  Future<List<T>> getAll(String table);
}
