import 'package:mylibrary/models/marker_base.dart';

class Author extends MarkerBase {
  final int? id;
  final String? name;

  new({required this.id, required this.name});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(id: json['id'] as int? ?? 0, name: json['name'] as String? ?? '');
  }

  @override
  Map<String, dynamic> toJson() => {'id': id ?? 0, 'name': name ?? '-'};
}
