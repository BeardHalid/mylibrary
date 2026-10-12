import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/models/marker_base.dart';

class BookResult extends MarkerBase {
  final List<Book> bookList;

  new({required this.bookList});

  factory BookResult.fromJson(Map<String, dynamic> json) {
    final list = json['results'] as List<Map<String, dynamic>>;
    return BookResult(
      bookList: list.map((book) => Book.fromJson(book)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'results': bookList.map((book) => book.toJson()).toList()};
  }
}
