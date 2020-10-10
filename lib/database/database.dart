import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

/// This class defines our database.
@UseMoor(tables: [Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  /// Will Instantiate or create database at the specified path
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'database.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}

/// This class holds table schema for [Tasks]
class Tasks extends Table {
  /// Task Id
  IntColumn get id => integer().autoIncrement()();

  /// Task name
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// Task completed status
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  /// Task due date
  DateTimeColumn get dueDate => dateTime().nullable()();

  /// Task start date
  DateTimeColumn get startDate => dateTime().nullable()();
}

/// This is a Data Access Object class, it defines different operations to be carried out on the Table
@UseDao(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  /// Reference to our [AppDatabase] instance;
  final AppDatabase database;

  /// Tasks Data Access Object
  TaskDao(this.database) : super(database);

  /// Fetches all the tasks in the database
  Future<List<Task>> getAllTasks() {
    return (select(tasks)
          ..orderBy(
            ([
              (t) =>
                  OrderingTerm(expression: t.startDate, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.name),
            ]),
          ))
        .get();
  }

  /// Streams all the tasks from the database and any changes made to them
  Stream<List<Task>> watchAllTasks() {
    return (select(tasks)
          ..orderBy(
            ([
              (t) =>
                  OrderingTerm(expression: t.startDate, mode: OrderingMode.asc),
              (t) => OrderingTerm(expression: t.name),
            ]),
          ))
        .watch();
  }

  /// Inserts a [Task] into the database
  Future<int> insertTask(Insertable<Task> task) => into(tasks).insert(task);

  /// Updates a [Task]
  Future<bool> updateTask(Insertable<Task> task) => update(tasks).replace(task);

  /// Deletes a [Task]
  Future<int> deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}
