import 'package:mylibrary/models/author.dart';
import 'package:mylibrary/models/marker_base.dart';

class Book extends MarkerBase {
  final int? id;
  final String? title;
  final List<Author>? authors;
  final String? coverImage;
  final String? summary;

  new({
    required this.id,
    required this.title,
    required this.authors,
    required this.coverImage,
    required this.summary,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final rawAuthors = json['authors'];
    final authorList = (rawAuthors is List)
        ? rawAuthors
              .whereType<Map>()
              .map(
                (author) => Author.fromJson(Map<String, dynamic>.from(author)),
              )
              .toList()
        : <Author>[];

    return Book(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      authors: authorList,
      coverImage: json['cover_image'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors != null
          ? authors!.map((author) => author.toJson()).toList()
          : [{}],
      'cover_image': coverImage,
      'summary': summary,
    };
  }
}
