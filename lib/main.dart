import 'package:flutter/material.dart';
import 'package:ia_chat/chat/presenter/page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: const MaterialApp(
        title: 'Material App',
        home: ChatPage(),
      ),
    );
  }
}
