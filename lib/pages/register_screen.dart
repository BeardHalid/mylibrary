import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/constants.dart';
import 'package:mylibrary/router.dart';
import 'package:mylibrary/states/auth_riverpod.dart';
import 'package:mylibrary/widgets/custom_button.dart';
import 'package:mylibrary/widgets/custom_snackbar.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _isSecure = true;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  border: OutlineInputBorder(),
                  labelText: 'Şifre',
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
              TextFormField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Şifre Tekrar',
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
                        if (_passwordController.text != _passwordConfirmController.text) {
                          log('Şifreler Eşleşmiyor :(');
                          return;
                        } else {
                          try {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signUp(_emailController.text, _passwordController.text);
                            if (context.mounted) {
                              CustomSnackbar.showSnackBar(
                                context,
                                Text('Kayıt Başarılı'),
                                Colors.green,
                              );
                              context.go(AppRoutes.homeScreen);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              CustomSnackbar.showSnackBar(context, Text(e.toString()), Colors.red);
                            }
                          }
                        }
                      }
                    },
                    text: 'Kayıt Ol',
                    width: Constants.screenWidth(context) * 0.45,
                  ),
                  CustomButton(
                    onPressed: () {
                      _emailController.clear();
                      _passwordController.clear();
                      _passwordConfirmController.clear();
                    },
                    text: 'Temizle',
                    width: Constants.screenWidth(context) * 0.45,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
