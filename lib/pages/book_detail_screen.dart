import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mylibrary/ai/ai_actions.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/models/favourite.dart';
import 'package:mylibrary/states/auth_riverpod.dart';
import 'package:mylibrary/states/favourites_screen_riverpod.dart';
import 'package:mylibrary/widgets/custom_button.dart';
import 'package:mylibrary/widgets/custom_snackbar.dart';

class BookDetailScreen extends StatefulWidget {
  final Book _book;
  const new({super.key, required this._book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isActive = false;
  bool _isTranslating = false;
  String? _translatedSummary;
  String get _summary => widget._book.summary ?? 'Özet Yok';

  @override
  Widget build(BuildContext context) {
    final displayedSummary = _isActive ? (_translatedSummary ?? _summary) : _summary;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._book.title ?? 'Başlık Yok', style: TextStyle(fontSize: 15.0)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            spacing: 20.0,
            children: [
              widget._book.coverImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10.0),
                      child: Image.network(widget._book.coverImage!),
                    )
                  : const Placeholder(),
              Text('Kitabın Yazarı : ${widget._book.authors?.first.name ?? 'Yazar Yok'}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Türkçe Çeviri : '),
                  Switch(
                    value: _isActive,
                    onChanged: (value) async {
                      _isActive = !_isActive;
                      if (value) {
                        setState(() {
                          _isTranslating = true;
                        });
                        _translatedSummary =
                            await AIActions(
                                  FirebaseAI.googleAI().generativeModel(model: 'gemini-3.8-flash'),
                                )
                                .translateSummary(_summary)
                                .whenComplete(() {
                                  setState(() {
                                    _isTranslating = false;
                                  });
                                })
                                .catchError((err) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(err.toString())));
                                  }
                                  return err.toString();
                                });
                      } else {
                        setState(() {
                          _translatedSummary = _summary;
                        });
                      }
                    },
                  ),
                  if (_isTranslating)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandableText(
                  linkColor: Colors.blueAccent,
                  textAlign: TextAlign.center,
                  animation: true,
                  maxLines: 5,
                  displayedSummary,
                  expandText: 'Daha fazla göster',
                  collapseText: 'Daha az göster',
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final authState = ref.read(authNotifierProvider);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      onPressed: () async {
                        if (authState.hasValue && authState.value != null) {
                          final b = widget._book;
                          final fav = Favourite(
                            id: b.id,
                            title: b.title,
                            authors: b.authors,
                            coverImage: b.coverImage,
                            summary: b.summary,
                            userId: authState.value?.uid,
                          );
                          final bookToAdd = await ref
                              .read(favouritesListProvider.notifier)
                              .addFavourite(fav);
                          if (context.mounted) {
                            CustomSnackbar.showSnackBar(
                              context,
                              Text(
                                bookToAdd
                                    ? 'Kitap favoilere eklendi'
                                    : 'Kitap zaten listenizde mevcut',
                              ),
                              bookToAdd ? Colors.green : Colors.red,
                            );
                          }
                        } else {
                          if (context.mounted) {
                            CustomSnackbar.showSnackBar(
                              context,
                              Center(
                                child: Text(
                                  'Favorilere eklemek için giriş yapmalısınız!',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Colors.red,
                            );
                          }
                        }
                      },
                      text: 'Favorilere Ekle',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
