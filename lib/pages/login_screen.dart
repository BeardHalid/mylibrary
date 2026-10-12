import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/router.dart';
import 'package:mylibrary/states/auth_riverpod.dart';
import 'package:mylibrary/constants.dart';
import 'package:mylibrary/widgets/custom_button.dart';
import 'package:mylibrary/widgets/custom_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSecure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-Mail', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E-mail boş bırakılamaz!';
                }
                return null;
              },
            ),
            Constants.verticalGap(16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isSecure = !_isSecure;
                    });
                  },
                  icon: Icon(Icons.password),
                ),
              ),
              obscureText: _isSecure,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre boş bırakılamaz!';
                }
                return null;
              },
            ),
            Constants.verticalGap(16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signIn(_emailController.text, _passwordController.text);
                        if (context.mounted) {
                          CustomSnackbar.showSnackBar(
                            context,
                            Text('Giriş işlemi başarılı'),
                            Colors.green,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          CustomSnackbar.showSnackBar(context, Text(e.toString()), Colors.red);
                        }
                      }
                    }
                  },
                  text: 'Giriş Yap',
                  width: Constants.screenWidth(context) * 0.45,
                ),
                CustomButton(
                  onPressed: () {
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  text: 'Temizle',
                  width: Constants.screenWidth(context) * 0.45,
                ),
              ],
            ),
            Constants.verticalGap(10.0),
            CustomButton(
              onPressed: () async {
                try {
                  await ref.read(authNotifierProvider.notifier).signInWithGoogle();
                  if (context.mounted) {
                    CustomSnackbar.showSnackBar(
                      context,
                      Text('Google ile giriş başarılı'),
                      Colors.green,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomSnackbar.showSnackBar(context, Text(e.toString()), Colors.red);
                  }
                }
              },
              text: 'Google ile Giriş Yap',
            ),
            Constants.verticalGap(10.0),
            CustomButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    String emailValue = '';
                    return AlertDialog(
                      title: Text('Şifre Sıfırlama'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email',
                            ),
                            onChanged: (value) => emailValue = value,
                          ),
                          Text(
                            '*Sisteme daha önceden kaydı yapılmış ve geçerli bir e-mail adresi girilmelidir.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .resetPassword(emailValue);
                              if (context.mounted) {
                                CustomSnackbar.showSnackBar(
                                  context,
                                  Text('Şifre başarıyla sıfırlandı.'),
                                  Colors.green,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.showSnackBar(
                                  context,
                                  Text(e.toString()),
                                  Colors.red,
                                );
                              }
                            }
                          },
                          child: Text('Gönder'),
                        ),
                      ],
                    );
                  },
                );
              },
              text: 'Şifremi Unuttum',
            ),
            Constants.verticalGap(10.0),
            CustomButton(
              onPressed: () {
                context.push(AppRoutes.registerScreen);
              },
              text: 'Kayıt Ol',
            ),
          ],
        ),
      ),
    );
  }
}
