import 'package:flutter_test/flutter_test.dart';
import 'package:flobster_core/flobster_core.dart';

void main() {
  group('FormDraft Model Tests', () {
    test('should correctly serialize and deserialize FormDraft properties', () {
      final now = DateTime.now();
      final draft = FormDraft(
        id: 'rec_1001',
        formId: 'invoice_form',
        draftData: {'customer': 'Acme Corp', 'amount': 1500.50},
        updatedAt: now,
      );

      final jsonMap = draft.toJson();
      expect(jsonMap['id'], 'rec_1001');
      expect(jsonMap['formId'], 'invoice_form');
      expect(jsonMap['draftData'], '{"customer":"Acme Corp","amount":1500.5}');
      expect(jsonMap['updatedAt'], now.toIso8601String());

      final restoredDraft = FormDraft.fromJson(jsonMap);
      expect(restoredDraft.id, 'rec_1001');
      expect(restoredDraft.formId, 'invoice_form');
      expect(restoredDraft.draftData['customer'], 'Acme Corp');
      expect(restoredDraft.draftData['amount'], 1500.50);
      expect(restoredDraft.updatedAt, now);
    });
  });
}
