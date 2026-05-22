import 'package:supabase_flutter/supabase_flutter.dart';
import 'repository.dart';

/// Generic Supabase data repository offering ready-made CRUD, soft-delete, and restoration queries.
/// Subclasses only need to implement [entityToMap] and [mapToEntity] to gain full database functionality.
abstract class SupabaseDataStoreRepository<T> implements DataStoreRepository<T> {
  final SupabaseClient client;
  final String tableName;
  final String primaryKeyName;

  SupabaseDataStoreRepository({
    required this.client,
    required this.tableName,
    this.primaryKeyName = 'id',
  });

  /// Map business entity to Supabase-compatible JSON structure.
  Map<String, dynamic> entityToMap(T entity);

  /// Reconstruct business entity from Supabase database row.
  T mapToEntity(Map<String, dynamic> map);

  @override
  Future<List<T>> findAll({bool includeDeleted = false}) async {
    dynamic query = client.from(tableName).select();
    if (!includeDeleted) {
      // Soft-delete rows omit items having non-null 'deleted_at' values
      query = query.isFilter('deleted_at', null);
    }
    final List<dynamic> response = await query;
    return response.map((row) => mapToEntity(row as Map<String, dynamic>)).toList();
  }

  @override
  Future<T?> findById(String id) async {
    final Map<String, dynamic>? response =
        await client.from(tableName).select().eq(primaryKeyName, id).maybeSingle();
    if (response == null) return null;
    return mapToEntity(response);
  }

  @override
  Future<void> save(T entity) async {
    final map = entityToMap(entity);
    await client.from(tableName).upsert(map);
  }

  @override
  Future<void> delete(String id) async {
    // Soft-delete stamps the current time in 'deleted_at'
    await client.from(tableName).update({
      'deleted_at': DateTime.now().toIso8601String(),
    }).eq(primaryKeyName, id);
  }

  @override
  Future<void> restore(String id) async {
    // Restoration resets 'deleted_at' to null
    await client.from(tableName).update({
      'deleted_at': null,
    }).eq(primaryKeyName, id);
  }
}
