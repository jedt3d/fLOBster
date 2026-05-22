import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:flobster_core/flobster_core.dart';

/// Concrete mock repository for testing submission and soft delete.
class MockRecord {
  final String id;
  final String name;
  MockRecord({required this.id, required this.name});
}

class MockRepository extends DataStoreRepository<MockRecord> {
  final List<MockRecord> database = [];
  final List<String> deletedIds = [];

  @override
  Future<void> save(MockRecord entity) async {
    database.add(entity);
  }

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
  }

  @override
  Future<List<MockRecord>> findAll({bool includeDeleted = false}) async => database;

  @override
  Future<MockRecord?> findById(String id) async => null;

  @override
  Future<void> restore(String id) async {
    deletedIds.remove(id);
  }
}

/// Concrete implementation of FlobsterViewModel for test assertions.
class TestFormViewModel extends FlobsterViewModel<MockRecord> {
  TestFormViewModel({
    required String recordId,
    required FormDraftManager draftManager,
    required DataStoreRepository<MockRecord> repository,
    Duration debounceDuration = const Duration(milliseconds: 50),
  }) : super(
          formId: 'test_form',
          recordId: recordId,
          draftManager: draftManager,
          repository: repository,
          debounceDuration: debounceDuration,
        );

  @override
  Map<String, String> validateFields(Map<String, dynamic> data) {
    final errors = <String, String>{};
    if (data['name'] == null || (data['name'] as String).isEmpty) {
      errors['name'] = 'Name cannot be empty';
    }
    return errors;
  }
}

void main() {
  late FormDraftDatabase db;
  late SqliteFormDraftManager draftManager;
  late MockRepository repository;

  setUp(() {
    // Initialize Drift in-memory database database executor
    db = FormDraftDatabase(NativeDatabase.memory());
    draftManager = SqliteFormDraftManager(db);
    repository = MockRepository();
  });

  tearDown(() async {
    await db.close();
  });

  group('SQLite Drift Draft Manager Tests', () {
    test('should save, retrieve, and clear dynamic draft data', () async {
      final now = DateTime.now();
      final draft = FormDraft(
        id: 'record_101',
        formId: 'customer_form',
        draftData: {'email': 'test@example.com', 'age': 30},
        updatedAt: now,
      );

      // Verify empty initial draft state
      var retrieved = await draftManager.getDraft('customer_form', 'record_101');
      expect(retrieved, isNull);

      // Save draft
      await draftManager.saveDraft(draft);

      // Retrieve and assert properties
      retrieved = await draftManager.getDraft('customer_form', 'record_101');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'record_101');
      expect(retrieved.draftData['email'], 'test@example.com');
      expect(retrieved.draftData['age'], 30);

      // Fetch all drafts count
      final allDrafts = await draftManager.getAllDrafts();
      expect(allDrafts.length, 1);

      // Clear draft
      await draftManager.clearDraft('customer_form', 'record_101');
      retrieved = await draftManager.getDraft('customer_form', 'record_101');
      expect(retrieved, isNull);
    });
  });

  group('FlobsterViewModel Integration Tests', () {
    test('should validate fields, trigger debounced autosave, and clear drafts on save', () async {
      final viewModel = TestFormViewModel(
        recordId: 'rec_999',
        draftManager: draftManager,
        repository: repository,
      );

      // Verify initial state
      expect(viewModel.state.recordId, 'rec_999');
      expect(viewModel.state.validationErrors, isEmpty);
      expect(viewModel.state.hasUnsavedDraft, false);

      // Trigger update containing field validation error
      viewModel.updateField('name', '');
      expect(viewModel.state.validationErrors['name'], 'Name cannot be empty');
      expect(viewModel.state.hasUnsavedDraft, true);

      // Resolve validation error
      viewModel.updateField('name', 'Acme Corporation');
      expect(viewModel.state.validationErrors, isEmpty);

      // Wait for debounced autosaving timer to complete execution
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert draft database entry was created
      final savedDraft = await draftManager.getDraft('test_form', 'rec_999');
      expect(savedDraft, isNotNull);
      expect(savedDraft!.draftData['name'], 'Acme Corporation');

      // Submit and save record
      final mockRecord = MockRecord(id: 'rec_999', name: 'Acme Corporation');
      await viewModel.submit(mockRecord);

      // Verify repository persist and draft deletion
      expect(repository.database.length, 1);
      expect(repository.database.first.name, 'Acme Corporation');

      final clearedDraft = await draftManager.getDraft('test_form', 'rec_999');
      expect(clearedDraft, isNull);
      expect(viewModel.state.hasUnsavedDraft, false);
    });

    test('should restore state from existing draft data on initialization', () async {
      final now = DateTime.now();
      final preExistingDraft = FormDraft(
        id: 'rec_555',
        formId: 'test_form',
        draftData: {'name': 'Pre-loaded Tenant'},
        updatedAt: now,
      );
      await draftManager.saveDraft(preExistingDraft);

      final viewModel = TestFormViewModel(
        recordId: 'rec_555',
        draftManager: draftManager,
        repository: repository,
      );

      // Micro-task yield to await draft check inside VM constructor
      await Future.delayed(Duration.zero);

      expect(viewModel.state.formData['name'], 'Pre-loaded Tenant');
      expect(viewModel.state.hasUnsavedDraft, true);
    });

    test('should successfully trigger soft delete workflow', () async {
      final viewModel = TestFormViewModel(
        recordId: 'rec_123',
        draftManager: draftManager,
        repository: repository,
      );

      viewModel.updateField('name', 'To Be Deleted');
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert draft saved
      var draft = await draftManager.getDraft('test_form', 'rec_123');
      expect(draft, isNotNull);

      // Perform soft delete
      await viewModel.softDelete();

      // Assert draft cleared and soft delete recorded in repository
      draft = await draftManager.getDraft('test_form', 'rec_123');
      expect(draft, isNull);
      expect(repository.deletedIds, contains('rec_123'));
    });
  });
}
