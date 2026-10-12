import 'package:mylibrary/models/author.dart';
import 'package:mylibrary/models/marker_base.dart';

class Favourite extends MarkerBase {
  final int? id;
  final String? title;
  final List<Author>? authors;
  final String? coverImage;
  final String? summary;
  final String? userId;

  new({
    required this.id,
    required this.title,
    required this.authors,
    required this.coverImage,
    required this.summary,
    required this.userId,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    final authorMapList = json['authors'];
    final authorList = (authorMapList is List)
        ? authorMapList
              .whereType<Map>()
              .map((author) => Author.fromJson(Map<String, dynamic>.from(author)))
              .toList()
        : <Author>[];
    return Favourite(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      authors: authorList,
      coverImage: json['coverImage'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors?.map((e) => e.toJson()).toList(),
      'coverImage': coverImage,
      'summary': summary,
      'userId': userId,
    };
  }
}
