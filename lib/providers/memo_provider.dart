import 'package:invoice_manage/features/memo/domain/memo.dart';

import '../core/constants/database_constants.dart';
import '../core/localdatabase/local_database_helper.dart';

class MemoDbProvider {
  MemoDbProvider._();

  static final MemoDbProvider db = MemoDbProvider._();

  Future<List<Memo>> getAllMemo() async {
    final db = await LocalDatabaseHelper.db.database;
    var res = await db.rawQuery("""
      SELECT *
      FROM ${DatabaseConstants.memoTable}
      LEFT JOIN ${DatabaseConstants.categoriesTable} ON ${DatabaseConstants.memoCateID} == ${DatabaseConstants.cateID}
    """);
    List<Memo> list =
        res.isNotEmpty ? res.map((c) => Memo.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newMemo(Memo newMemo) async {
    final db = await LocalDatabaseHelper.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery(
        "SELECT MAX(${DatabaseConstants.memoID})+1 as id FROM ${DatabaseConstants.memoTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    if (newMemo.memoContent!.isEmpty) newMemo.memoContent = "MEMO #$id";
    await db.rawInsert(
        "INSERT Into ${DatabaseConstants.memoTable} ("
        "${DatabaseConstants.memoID},"
        "${DatabaseConstants.isMemoEdited},"
        "${DatabaseConstants.memoContent},"
        "${DatabaseConstants.memoCateID})"
        " VALUES (?,?,?,?)",
        [id, newMemo.isMemoEdited, newMemo.memoContent, newMemo.memoCateID]);
  }

  Future<void> updateMemo(Memo old, Memo up) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(
        DatabaseConstants.memoTable,
        {
          DatabaseConstants.isMemoEdited: up.isMemoEdited,
          DatabaseConstants.memoContent: up.memoContent,
          DatabaseConstants.memoCateID: up.memoCateID
        },
        where: "${DatabaseConstants.memoID} = ?",
        whereArgs: [old.memoID]);
  }

  Future<void> deleteMemo(Memo del) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.memoTable,
        where: "${DatabaseConstants.memoID} = ?", whereArgs: [del.memoID]);
  }
}
