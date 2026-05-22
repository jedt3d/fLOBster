import 'package:drift/drift.dart';
import 'draft_table.dart';

part 'draft_db.g.dart';

@DriftDatabase(tables: [FormDrafts])
class FormDraftDatabase extends _$FormDraftDatabase {
  FormDraftDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  /// Fetches all active saved drafts in local storage.
  Future<List<FormDraftData>> fetchAllDrafts() => select(formDrafts).get();

  /// Fetches a single draft by unique ID and form page ID.
  Future<FormDraftData?> fetchDraft(String id, String formId) {
    return (select(formDrafts)..where((t) => t.id.equals(id) & t.formId.equals(formId)))
        .getSingleOrNull();
  }

  /// Saves or updates a dynamic form draft.
  Future<void> persistDraft(FormDraftsCompanion companion) async {
    await into(formDrafts).insertOnConflictUpdate(companion);
  }

  /// Removes an in-progress draft from SQLite storage.
  Future<void> removeDraft(String id, String formId) async {
    await (delete(formDrafts)..where((t) => t.id.equals(id) & t.formId.equals(formId))).go();
  }
}
