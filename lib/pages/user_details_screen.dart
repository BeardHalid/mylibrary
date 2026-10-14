import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylibrary/constants.dart';
import 'package:mylibrary/exception/base_exception.dart';
import 'package:mylibrary/locator.dart';
import 'package:mylibrary/states/auth_riverpod.dart';
import 'package:mylibrary/states/error_catch_riverpod.dart';
import 'package:mylibrary/storage/istorage_repository.dart';
import 'package:mylibrary/widgets/custom_button.dart';
import 'package:mylibrary/widgets/custom_snackbar.dart';
import 'package:mylibrary/widgets/custom_text.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  bool _isPhotoUploading = false;

  Future<void> _uploadPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file == null) return;

    if (!mounted) return;
    setState(() => _isPhotoUploading = true);

    try {
      final urlPath = await getIt<IStorageRepository>().set(File(file.path), file.name);
      await ref.read(authNotifierProvider.notifier).updatePhotoURL(urlPath);

      if (mounted) {
        CustomSnackbar.showSnackBar(
          context,
          const CustomText(text: 'Fotoğraf güncelleme başarılı'),
          Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showSnackBar(context, CustomText(text: 'Hata : $e'), Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isPhotoUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifierPrv = ref.watch(authNotifierProvider);

    ref.listen<BaseException?>(errorCatchProvider, (prev, next) {
      if (next == null) return;
      CustomSnackbar.showSnackBar(context, CustomText(text: next.result), next.color);
      ref.read(errorCatchProvider.notifier).state = null;
    });

    return authNotifierPrv.when(
      data: (user) {
        if (user != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20.0,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        constraints: BoxConstraints.tight(const Size(100, 100)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1.5),
                        ),
                        child: _isPhotoUploading
                            ? const Center(child: CircularProgressIndicator())
                            : user.photoURL != null
                            ? ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(9.0),
                                child: Image.network(user.photoURL!),
                              )
                            : const Icon(Icons.account_circle_rounded),
                      ),
                      Positioned(
                        right: -10.0,
                        bottom: -10.0,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (sheetContext) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 15.0,
                                    children: [
                                      CustomButton(
                                        text: 'Galeriden',
                                        onPressed: () async {
                                          Navigator.of(sheetContext).pop();
                                          await _uploadPhoto(ImageSource.gallery);
                                        },
                                      ),
                                      CustomButton(
                                        text: 'Kameradan',
                                        onPressed: () async {
                                          Navigator.of(sheetContext).pop();
                                          await _uploadPhoto(ImageSource.camera);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.photo_camera, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                Constants.verticalGap(50.0),
                user.displayName != null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(text: 'Sayın ${user.displayName}'),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'Kullanıcı adı bulunamadı',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                user.email != null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(text: 'E-mail : ${user.email}'),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'E-mail bilgisi bulunamadı',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                user.phoneNumber != null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(text: 'Telefon numarası : ${user.phoneNumber}'),
                      )
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: 'Telefon numarası bulunamadı',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                Constants.verticalGap(50.0),
                CustomButton(
                  width: Constants.screenWidth(context) * 0.9,
                  text: 'Şifreyi Güncelle',
                  onPressed: () async {
                    String? newPassword;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const CustomText(
                            text: '...Yeni Şifre...',
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                          content: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Yeni şifre...',
                                hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13.0),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  newPassword = value;
                                } else {
                                  newPassword = null;
                                }
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const CustomText(text: 'İptal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (newPassword != null) {
                                  await ref
                                      .read(authNotifierProvider.notifier)
                                      .updatePassword(newPassword!);
                                } else {
                                  Navigator.of(context).pop();
                                  CustomSnackbar.showSnackBar(
                                    context,
                                    CustomText(text: 'Şifre güncelleme alanı boş bırakılamaz!'),
                                    Colors.red,
                                  );
                                }
                              },
                              child: const CustomText(text: 'Şifreyi Güncelle'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                CustomButton(
                  width: Constants.screenWidth(context) * 0.9,
                  text: 'İsim Güncelle',
                  onPressed: () async {
                    String? newDisplayName;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const CustomText(
                            text: '...Yeni İsim...',
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                          content: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Yeni isim...',
                                hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13.0),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  newDisplayName = value;
                                } else {
                                  newDisplayName = null;
                                }
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const CustomText(text: 'İptal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (newDisplayName != null) {
                                  Navigator.of(context).pop();
                                  await ref
                                      .read(authNotifierProvider.notifier)
                                      .updateDisplayName(newDisplayName!);
                                } else {
                                  Navigator.of(context).pop();
                                  CustomSnackbar.showSnackBar(
                                    context,
                                    const CustomText(
                                      text: 'İsim güncelleme alanı boş bırakılamaz!',
                                    ),
                                    Colors.red,
                                  );
                                }
                              },
                              child: const CustomText(text: 'İsmi Güncelle'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                CustomButton(
                  width: Constants.screenWidth(context) * 0.9,
                  text: 'Telefon Numarası Güncelle',
                  onPressed: () async {
                    String? newPhoneNumber;
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const CustomText(
                            text: '...Yeni İsim...',
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                          content: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Yeni telefon numarası...',
                                hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13.0),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  newPhoneNumber = value;
                                } else {
                                  newPhoneNumber = null;
                                }
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const CustomText(text: 'İptal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (newPhoneNumber != null) {
                                  Navigator.of(context).pop();
                                  await ref
                                      .read(authNotifierProvider.notifier)
                                      .updatePhoneNumber(newPhoneNumber!);
                                } else {
                                  Navigator.of(context).pop();
                                  CustomSnackbar.showSnackBar(
                                    context,
                                    const CustomText(
                                      text: 'Telefon numarası güncelleme alanı boş bırakılamaz!',
                                    ),
                                    Colors.red,
                                  );
                                }
                              },
                              child: const CustomText(text: 'Telefon Numarası Güncelle'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                CustomButton(
                  width: Constants.screenWidth(context) * 0.9,
                  text: 'Çıkış Yap',
                  onPressed: () async {
                    try {
                      await ref.read(authNotifierProvider.notifier).signOut();
                      if (context.mounted) {
                        CustomSnackbar.showSnackBar(
                          context,
                          const CustomText(text: 'Çıkış işlemi başarılı'),
                          Colors.green,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        CustomSnackbar.showSnackBar(
                          context,
                          CustomText(text: e.toString()),
                          Colors.red,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.no_accounts_rounded),
                Constants.verticalGap(10),
                const CustomText(text: 'Kullanıcı bulunamadı :('),
              ],
            ),
          );
        }
      },
      error: (error, st) => Center(child: CustomText(text: error.toString())),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
