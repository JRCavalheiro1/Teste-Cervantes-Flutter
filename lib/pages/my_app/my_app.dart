import 'package:cadastro_flutter/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Color(0x8985D1FA),
            cursorColor: Color(0xFF37abe8),
            selectionHandleColor: Color(0xFF37abe8),
          )),
      home: HomePage(),
    );
  }
}
