import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agrobanco_home_banking/main.dart';

void main() {
  testWidgets('App shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AgrobancoApp());
    expect(find.text('Agrobanco'), findsWidgets);
  });
}
