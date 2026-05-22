import 'package:postgres/postgres.dart';
import 'repository.dart';

/// Generic PostgreSQL data repository providing secure SQL CRUD operations, upserts, and soft-delete/restore commands.
/// Designed for direct intranet server-db ties. Subclasses map columns through [entityToMap] and [mapToEntity].
abstract class PostgresDataStoreRepository<T> implements DataStoreRepository<T> {
  final Connection connection;
  final String tableName;
  final String primaryKeyName;

  PostgresDataStoreRepository({
    required this.connection,
    required this.tableName,
    this.primaryKeyName = 'id',
  });

  /// Map business entity to PostgreSQL parameterized values.
  Map<String, dynamic> entityToMap(T entity);

  /// Map database row elements to business entity.
  T mapToEntity(Map<String, dynamic> map);

  @override
  Future<List<T>> findAll({bool includeDeleted = false}) async {
    final queryStr = includeDeleted
        ? 'SELECT * FROM $tableName'
        : 'SELECT * FROM $tableName WHERE deleted_at IS NULL';
    final result = await connection.execute(queryStr);
    return result.map((row) => mapToEntity(row.toColumnMap())).toList();
  }

  @override
  Future<T?> findById(String id) async {
    final result = await connection.execute(
      Sql.named('SELECT * FROM $tableName WHERE $primaryKeyName = @id'),
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return mapToEntity(result.first.toColumnMap());
  }

  @override
  Future<void> save(T entity) async {
    final map = entityToMap(entity);
    final keys = map.keys.join(', ');
    final placeholders = map.keys.map((k) => '@$k').join(', ');
    final updates = map.keys.map((k) => '$k = EXCLUDED.$k').join(', ');

    final queryStr = '''
      INSERT INTO $tableName ($keys) 
      VALUES ($placeholders) 
      ON CONFLICT ($primaryKeyName) 
      DO UPDATE SET $updates
    ''';

    await connection.execute(
      Sql.named(queryStr),
      parameters: map,
    );
  }

  @override
  Future<void> delete(String id) async {
    await connection.execute(
      Sql.named('UPDATE $tableName SET deleted_at = @now WHERE $primaryKeyName = @id'),
      parameters: {
        'id': id,
        'now': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> restore(String id) async {
    await connection.execute(
      Sql.named('UPDATE $tableName SET deleted_at = NULL WHERE $primaryKeyName = @id'),
      parameters: {'id': id},
    );
  }
}
