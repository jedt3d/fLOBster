/// Base repository interface representing core data store CRUD operations.
/// Supports soft-delete and restore workflows.
abstract class DataStoreRepository<T> {
  /// Fetches all active (non-soft-deleted) records.
  Future<List<T>> findAll({bool includeDeleted = false});

  /// Fetches a single record by its unique ID.
  Future<T?> findById(String id);

  /// Persists or updates a record.
  Future<void> save(T entity);

  /// Performs a soft-delete on the record.
  Future<void> delete(String id);

  /// Restores a soft-deleted record.
  Future<void> restore(String id);
}
