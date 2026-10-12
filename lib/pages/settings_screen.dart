import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Karanlık / Aydınlık Modu'),
          trailing: Switch(
            value: _isDark,
            onChanged: (value) => setState(() {
              _isDark = !_isDark;
            }),
          ),
        ),
        ListTile(
          title: Text('Hakkımızda'),
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                content: Text('Hakkımızda'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('Kapat'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
