import 'package:mustache_template/mustache_template.dart';

/// Compiler for generating dynamic HTML-based Line of Business reports.
/// Utilizes Mustache/Liquid templating patterns.
class FlobsterHtmlReporter {
  FlobsterHtmlReporter._();

  /// Compiles a report layout with active data context.
  static String compile({
    required String templateContent,
    required Map<String, dynamic> dataContext,
  }) {
    final template = Template(
      templateContent,
      htmlEscapeValues: true,
      lenient: true,
    );
    return template.renderString(dataContext);
  }

  /// Standard invoice HTML template skeleton with premium modern styles embedded.
  static const String invoiceTemplateSkeleton = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Invoice {{invoiceNumber}}</title>
  <style>
    body {
      font-family: 'Outfit', 'Inter', sans-serif;
      background-color: #0F111A;
      color: #FFFFFF;
      margin: 40px;
    }
    .invoice-card {
      background: rgba(30, 34, 51, 0.7);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 16px;
      padding: 30px;
      box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
    }
    .header {
      display: flex;
      justify-content: space-between;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      padding-bottom: 20px;
      margin-bottom: 20px;
    }
    .title {
      font-size: 24px;
      font-weight: bold;
      background: linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .meta {
      color: #A0A5C0;
      text-align: right;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 30px;
    }
    th, td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }
    th {
      color: #00F2FE;
    }
    .total-row {
      font-weight: bold;
      font-size: 18px;
      color: #00F5A0;
    }
  </style>
</head>
<body>
  <div class="invoice-card">
    <div class="header">
      <div>
        <div class="title">{{companyName}}</div>
        <div>{{companyAddress}}</div>
      </div>
      <div class="meta">
        <div><strong>Invoice #:</strong> {{invoiceNumber}}</div>
        <div><strong>Date:</strong> {{invoiceDate}}</div>
      </div>
    </div>
    
    <h3>Bill To:</h3>
    <p>{{clientName}}<br>{{clientAddress}}</p>

    <table>
      <thead>
        <tr>
          <th>Item Description</th>
          <th>Qty</th>
          <th>Unit Price</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        {{#items}}
        <tr>
          <td>{{description}}</td>
          <td>{{quantity}}</td>
          <td>\${{unitPrice}}</td>
          <td>\${{totalPrice}}</td>
        </tr>
        {{/items}}
        <tr class="total-row">
          <td colspan="3" style="text-align: right;">Grand Total:</td>
          <td>\${{grandTotal}}</td>
        </tr>
      </tbody>
    </table>
  </div>
</body>
</html>
''';
}
