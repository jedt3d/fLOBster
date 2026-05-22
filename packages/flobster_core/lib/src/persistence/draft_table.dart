import 'package:drift/drift.dart';

/// Drift table representing autosaved form drafts.
@DataClassName('FormDraftData')
class FormDrafts extends Table {
  /// Unique identifier of the record or draft
  TextColumn get id => text()();

  /// Form identifier mapping to a specific view
  TextColumn get formId => text()();

  /// Serialized dynamic form content stored as a JSON string
  TextColumn get draftData => text()();

  /// Timestamp when the draft was last updated
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id, formId};
}
