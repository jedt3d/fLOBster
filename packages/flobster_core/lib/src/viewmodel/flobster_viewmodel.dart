import 'dart:async';
import 'package:riverpod/riverpod.dart';
import '../../flobster_core.dart';

/// Base state class representing a dynamic form editor state.
class FlobsterFormState<T> {
  final String recordId;
  final Map<String, dynamic> formData;
  final Map<String, String> validationErrors;
  final bool isSaving;
  final bool hasUnsavedDraft;

  FlobsterFormState({
    required this.recordId,
    required this.formData,
    this.validationErrors = const {},
    this.isSaving = false,
    this.hasUnsavedDraft = false,
  });

  FlobsterFormState<T> copyWith({
    String? recordId,
    Map<String, dynamic>? formData,
    Map<String, String>? validationErrors,
    bool? isSaving,
    bool? hasUnsavedDraft,
  }) {
    return FlobsterFormState<T>(
      recordId: recordId ?? this.recordId,
      formData: formData ?? this.formData,
      validationErrors: validationErrors ?? this.validationErrors,
      isSaving: isSaving ?? this.isSaving,
      hasUnsavedDraft: hasUnsavedDraft ?? this.hasUnsavedDraft,
    );
  }
}

/// Abstract base class for ViewModels handling Line of Business forms.
/// Integrates automated debounced autosaving, recovery, and form validation.
abstract class FlobsterViewModel<T> extends StateNotifier<FlobsterFormState<T>> {
  final String formId;
  final FormDraftManager draftManager;
  final DataStoreRepository<T>? repository;

  Timer? _debounceTimer;
  final Duration debounceDuration;

  FlobsterViewModel({
    required this.formId,
    required String recordId,
    required this.draftManager,
    this.repository,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super(FlobsterFormState<T>(
          recordId: recordId,
          formData: {},
        )) {
    _checkForExistingDraft();
  }

  /// Override to define validation logic for fields.
  /// Returns a map of field keys to error messages.
  Map<String, String> validateFields(Map<String, dynamic> data) => const {};

  /// Update a single form field and trigger debounced autosave.
  void updateField(String key, dynamic value) {
    final updatedData = Map<String, dynamic>.from(state.formData)..[key] = value;
    final errors = validateFields(updatedData);

    state = state.copyWith(
      formData: updatedData,
      validationErrors: errors,
      hasUnsavedDraft: true,
    );

    _triggerAutosave();
  }

  /// Debounce local SQLite draft persistence.
  void _triggerAutosave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, _performAutosave);
  }

  Future<void> _performAutosave() async {
    final draft = FormDraft(
      id: state.recordId,
      formId: formId,
      draftData: state.formData,
      updatedAt: DateTime.now(),
    );
    await draftManager.saveDraft(draft);
  }

  /// Recover an existing draft if it exists in local SQLite database.
  Future<void> _checkForExistingDraft() async {
    final existing = await draftManager.getDraft(formId, state.recordId);
    if (existing != null) {
      state = state.copyWith(
        formData: existing.draftData,
        validationErrors: validateFields(existing.draftData),
        hasUnsavedDraft: true,
      );
    }
  }

  /// Submits the form data and purges the cached draft.
  Future<void> submit(T entity) async {
    if (state.validationErrors.isNotEmpty) return;
    
    state = state.copyWith(isSaving: true);
    
    try {
      if (repository != null) {
        await repository!.save(entity);
      }
      await draftManager.clearDraft(formId, state.recordId);
      state = state.copyWith(
        isSaving: false,
        hasUnsavedDraft: false,
      );
    } catch (_) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }

  /// Performs soft-delete on a database entity.
  Future<void> softDelete() async {
    if (repository != null) {
      await repository!.delete(state.recordId);
    }
    await draftManager.clearDraft(formId, state.recordId);
    state = state.copyWith(hasUnsavedDraft: false);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
