import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'summary.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Wikipedia Flutter'),),
        body: Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
