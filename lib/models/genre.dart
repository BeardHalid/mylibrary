import 'package:mylibrary/models/marker_base.dart';

class Genre extends MarkerBase {
  final int? id;
  final String? name;

  new({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id ?? 0, 'name': name ?? ''};
  }
}
