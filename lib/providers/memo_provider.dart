import 'package:invoice_manage/model/memo.dart';

import 'db_provider.dart';

class MemoDbProvider {
  MemoDbProvider._();

  static final MemoDbProvider db = MemoDbProvider._();

  Future<List<Memo>> getAllMemo() async {
    final db = await DbProvider.db.database;
    var res = await db.rawQuery("""
      SELECT *
      FROM ${DbProvider.memoTable}
      LEFT JOIN ${DbProvider.categoriesTable} ON ${DbProvider.memoCateID} == ${DbProvider.cateID}
    """);
    List<Memo> list = res.isNotEmpty ? res.map((c) => Memo.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newMemo(Memo newMemo) async {
    final db = await DbProvider.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(${DbProvider.memoID})+1 as id FROM ${DbProvider.memoTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    await db.rawInsert(
        "INSERT Into ${DbProvider.memoTable} ("
            "${DbProvider.memoID},"
            "${DbProvider.memoContent},"
            "${DbProvider.memoCateID})"
            " VALUES (?,?,?)",
        [id, newMemo.memoContent, newMemo.memoCateID]);
  }

  Future<void> updateMemo(Memo old, Memo up) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.memoTable,
        {
          DbProvider.memoContent: up.memoContent,
          DbProvider.memoCateID: up.memoCateID
        },
        where: "${DbProvider.memoID} = ?",
        whereArgs: [old.memoID]
    );
  }

  Future<void> deleteMemo(Memo del) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.memoTable,
        where: "${DbProvider.memoID} = ?",
        whereArgs: [del.memoID]
    );
  }
}