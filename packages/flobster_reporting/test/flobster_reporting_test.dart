import 'package:flutter_test/flutter_test.dart';
import 'package:flobster_reporting/flobster_reporting.dart';

void main() {
  group('Flobster Reporting Engine Tests', () {
    test('HTML Mustache Reporter correctly compiles templates', () {
      final template = 'Hello {{name}}! Welcome to {{platform}}.';
      final data = {'name': 'worajedt', 'platform': 'fLOBster'};

      final result = FlobsterHtmlReporter.compile(
        templateContent: template,
        dataContext: data,
      );

      expect(result, 'Hello worajedt! Welcome to fLOBster.');
    });

    test('HTML Reporter invoice template compile matches fields', () {
      final invoiceData = {
        'companyName': 'jedt3d Development',
        'companyAddress': 'Bangkok, Thailand',
        'invoiceNumber': 'INV-2026-999',
        'invoiceDate': '2026-05-22',
        'clientName': 'Acme Inc',
        'clientAddress': 'Silicon Valley, CA',
        'items': [
          {'description': 'fLOBster License', 'quantity': 1, 'unitPrice': 4999.00, 'totalPrice': 4999.00},
          {'description': 'Consulting Hour', 'quantity': 5, 'unitPrice': 150.00, 'totalPrice': 750.00}
        ],
        'grandTotal': 5749.00
      };

      final htmlResult = FlobsterHtmlReporter.compile(
        templateContent: FlobsterHtmlReporter.invoiceTemplateSkeleton,
        dataContext: invoiceData,
      );

      expect(htmlResult.contains('jedt3d Development'), true);
      expect(htmlResult.contains('INV-2026-999'), true);
      expect(htmlResult.contains('fLOBster License'), true);
      expect(htmlResult.contains('\$5749'), true);
    });
  });
}
