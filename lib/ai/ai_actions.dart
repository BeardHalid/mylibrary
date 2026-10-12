import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';

class AIActions {
  //final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: '');

  final GenerativeModel _model;
  AIActions(this._model);

  Future<String?> translateSummary(String summary) async {
    //final apiKey = String.fromEnvironment('GEMINI_API_KEY');
    String? translation;
    try {
      final response = await _model.generateContent([
        Content.text(
          'Aşağıdaki kitap özetini Türkçeye çevir. '
          'Yalnızca çeviriyi döndür:\n\n$summary',
        ),
      ]);
      translation = response.text?.trim();
      if (translation == null || translation.isEmpty) {
        log('Gemini boş yanıt döndürdü');
      }
    } catch (e) {
      translation = null;
      log('Özet çevrilemedi : ${e.toString()}');
    }
    return translation;
  }
}
