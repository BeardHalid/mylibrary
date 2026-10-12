import 'package:mylibrary/models/marker_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mylibrary/repository/core/igutenberg_repository.dart';

class GutenbergRepository<T extends MarkerBase> implements IGutenbergRepository<T> {
  static String get baseUrl => dotenv.get('GUTENBERG_API_BASE_URL');
  static String get apiKey => dotenv.get('GUTENBERG_API_KEY');

  final Dio _client;
  final T Function(Map<String, dynamic>) fromJson;

  GutenbergRepository({required this._client, required this.fromJson});

  @override
  Future<List<T>> getAll(String table) async {
    final response = await _client.get(
      '$baseUrl$table',
      options: Options(headers: {'x-rapidapi-key': apiKey}),
    );

    final responseMap = response.data as Map<String, dynamic>;
    final responseList = responseMap['results'] as List<dynamic>;
    final jsonList = responseList
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return jsonList.map(fromJson).toList();
  }

  @override
  Future<List<T>?> search(String table, String filter, String query) async {
    final response = await _client.get(
      '$baseUrl$table?$filter=$query',
      options: Options(headers: {'x-rapidapi-key': apiKey}),
    );
    List<Map<String, dynamic>>? jsonList;
    try {
      final responseMap = response.data as Map<String, dynamic>;
      final responseList = responseMap['results'] as List<dynamic>;
      jsonList = responseList.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      jsonList = null;
      throw Exception(e);
    }
    return jsonList.map(fromJson).toList();
  }
}
