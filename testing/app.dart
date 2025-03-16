import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testApp(
  WidgetTester tester,
  Widget body,
) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: body),
    ),
  );
}
