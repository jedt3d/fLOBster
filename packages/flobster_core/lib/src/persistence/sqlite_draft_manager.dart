import 'dart:convert';
import 'package:drift/drift.dart';
import '../models/draft.dart';
import 'draft_db.dart';

/// SQLite implementation of the FormDraftManager persistence interface using Drift.
class SqliteFormDraftManager implements FormDraftManager {
  final FormDraftDatabase db;

  SqliteFormDraftManager(this.db);

  @override
  Future<void> saveDraft(FormDraft draft) async {
    final companion = FormDraftsCompanion(
      id: Value(draft.id),
      formId: Value(draft.formId),
      draftData: Value(jsonEncode(draft.draftData)),
      updatedAt: Value(draft.updatedAt),
    );
    await db.persistDraft(companion);
  }

  @override
  Future<FormDraft?> getDraft(String formId, String recordId) async {
    final data = await db.fetchDraft(recordId, formId);
    if (data == null) return null;
    return FormDraft(
      id: data.id,
      formId: data.formId,
      draftData: Map<String, dynamic>.from(jsonDecode(data.draftData) as Map),
      updatedAt: data.updatedAt,
    );
  }

  @override
  Future<void> clearDraft(String formId, String recordId) async {
    await db.removeDraft(recordId, formId);
  }

  @override
  Future<List<FormDraft>> getAllDrafts() async {
    final list = await db.fetchAllDrafts();
    return list.map((data) => FormDraft(
      id: data.id,
      formId: data.formId,
      draftData: Map<String, dynamic>.from(jsonDecode(data.draftData) as Map),
      updatedAt: data.updatedAt,
    )).toList();
  }
}
