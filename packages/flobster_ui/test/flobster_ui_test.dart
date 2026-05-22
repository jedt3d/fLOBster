import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flobster_ui/flobster_ui.dart';

void main() {
  group('Flobster UI Design System Tests', () {
    test('FlobsterColors contains correct HEX colors', () {
      expect(FlobsterColors.darkBackground, const Color(0xFF0F111A));
      expect(FlobsterColors.brandCyan, const Color(0xFF00F2FE));
      expect(FlobsterColors.brandBlue, const Color(0xFF4FACFE));
      expect(FlobsterColors.successMint, const Color(0xFF00F5A0));
      expect(FlobsterColors.warningRose, const Color(0xFFFF4B6E));
    });

    testWidgets('GlassBox renders correctly with child', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBox(
              child: Text('Inspected Record', key: Key('child_text')),
            ),
          ),
        ),
      );

      final textFinder = find.byKey(const Key('child_text'));
      expect(textFinder, findsOneWidget);
      expect(find.text('Inspected Record'), findsOneWidget);
    });
  });
}
