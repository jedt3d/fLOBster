import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// High-performance native PDF report generator for business applications.
class FlobsterPdfReporter {
  FlobsterPdfReporter._();

  /// Generates a structured invoice document.
  static Future<Uint8List> generateInvoice({
    required String companyName,
    required String invoiceNumber,
    required String invoiceDate,
    required String clientName,
    required double grandTotal,
    required List<Map<String, dynamic>> items,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(companyName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('Invoice #: $invoiceNumber', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Invoice Date: $invoiceDate'),
          pw.Text('Client: $clientName'),
          pw.SizedBox(height: 30),
          pw.Table.fromTextArray(
            headers: ['Description', 'Qty', 'Unit Price', 'Total'],
            data: items.map((item) {
              return [
                item['description']?.toString() ?? '',
                item['quantity']?.toString() ?? '0',
                '\$${item['unitPrice']?.toString() ?? '0.00'}',
                '\$${item['totalPrice']?.toString() ?? '0.00'}',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
