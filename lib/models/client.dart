import 'package:mylibrary/models/marker_base.dart';

class Client extends MarkerBase {
  final String? id;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;

  Client({
    required this.id,
    required this.displayName,
    required this.phoneNumber,
    required this.photoURL,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'displayName': displayName, 'phoneNumber': phoneNumber, 'photoURL': photoURL};
  }
}
