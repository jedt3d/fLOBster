import 'package:flobster_desktop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the Contact Management desktop shell', (tester) async {
    await tester.pumpWidget(const FlobsterDesktopApp());

    expect(find.text('Contact Management'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Companies'), findsOneWidget);
    expect(find.text('Organizations'), findsOneWidget);
    expect(find.text('Anika Rao'), findsOneWidget);
  });

  testWidgets('switches between contact record sections', (tester) async {
    await tester.pumpWidget(const FlobsterDesktopApp());

    await tester.tap(find.text('Companies'));
    await tester.pumpAndSettle();

    expect(find.text('Northwind Trading'), findsOneWidget);
    expect(find.text('Food distribution company'), findsOneWidget);

    await tester.tap(find.text('Organizations'));
    await tester.pumpAndSettle();

    expect(find.text('City Commerce Office'), findsOneWidget);
    expect(find.text('Government services organization'), findsOneWidget);
  });

  testWidgets('hides destructive actions from standard users', (tester) async {
    await tester.pumpWidget(const FlobsterDesktopApp());

    expect(find.text('Standard user'), findsOneWidget);
    expect(find.text('Delete'), findsNothing);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });
}
