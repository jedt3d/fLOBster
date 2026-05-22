import 'dart:convert';

/// Represents an autosaved, in-progress draft of a form.
class FormDraft {
  final String id;
  final String formId;
  final Map<String, dynamic> draftData;
  final DateTime updatedAt;

  FormDraft({
    required this.id,
    required this.formId,
    required this.draftData,
    required this.updatedAt,
  });

  /// Serializes to a standard JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'draftData': jsonEncode(draftData),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Deserializes from a JSON map.
  factory FormDraft.fromJson(Map<String, dynamic> map) {
    return FormDraft(
      id: map['id'] as String,
      formId: map['formId'] as String,
      draftData: Map<String, dynamic>.from(
        jsonDecode(map['draftData'] as String) as Map,
      ),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}

/// Abstract contract for managing form draft persistence locally.
abstract class FormDraftManager {
  /// Save or update an in-progress draft.
  Future<void> saveDraft(FormDraft draft);

  /// Fetch an existing draft by form and record ID.
  Future<FormDraft?> getDraft(String formId, String recordId);

  /// Discard a draft (e.g. after successful submission).
  Future<void> clearDraft(String formId, String recordId);

  /// Fetch all active drafts.
  Future<List<FormDraft>> getAllDrafts();
}
