import '../../constants/database_constants.dart';

class DatabaseMigrationScripts {
  static final migrationScripts = [_firstMigration, _secondMigration];

  static final _firstMigration = [
    """ALTER TABLE ${DatabaseConstants.orderHeadTable} RENAME TO OrderHeadOld""",
    """ALTER TABLE ${DatabaseConstants.orderListTable} RENAME TO OrderListOld""",
    """CREATE TABLE ${DatabaseConstants.orderHeadTable} (
            ${DatabaseConstants.orderID}	INTEGER NOT NULL,
            ${DatabaseConstants.payType}	TEXT NOT NULL,
            ${DatabaseConstants.soldTo}	TEXT,
            ${DatabaseConstants.total}	REAL NOT NULL,
            ${DatabaseConstants.date} TEXT NOT NULL,
            PRIMARY KEY(${DatabaseConstants.orderID})
          );
          """,
    """CREATE TABLE ${DatabaseConstants.orderListTable} (
            ${DatabaseConstants.orderListId} INTEGER NOT NULL,
            ${DatabaseConstants.orderID}	INTEGER NOT NULL,
            ${DatabaseConstants.itemID}	INTEGER NOT NULL,
            ${DatabaseConstants.listPrice}	REAL NOT NULL,
            ${DatabaseConstants.qty}	INTEGER NOT NULL,
            PRIMARY KEY(${DatabaseConstants.orderListId})
            FOREIGN KEY(${DatabaseConstants.orderID}) REFERENCES ${DatabaseConstants.orderHeadTable}(${DatabaseConstants.orderID}) ON DELETE CASCADE,
            FOREIGN KEY(${DatabaseConstants.itemID}) REFERENCES ${DatabaseConstants.catalogTable}(${DatabaseConstants.itemID}) ON DELETE CASCADE
          )""",
    """INSERT INTO ${DatabaseConstants.orderHeadTable} (${DatabaseConstants.orderID}, ${DatabaseConstants.payType}, ${DatabaseConstants.total}, ${DatabaseConstants.date})
    SELECT ${DatabaseConstants.orderID}, ${DatabaseConstants.payType}, ${DatabaseConstants.total}, ${DatabaseConstants.date}
    FROM OrderHeadOld""",
    """INSERT INTO ${DatabaseConstants.orderListTable} (${DatabaseConstants.orderID}, ${DatabaseConstants.itemID}, ${DatabaseConstants.listPrice}, ${DatabaseConstants.qty})
    SELECT ${DatabaseConstants.orderID}, ${DatabaseConstants.itemID}, ${DatabaseConstants.listPrice}, ${DatabaseConstants.qty}
    FROM OrderListOld""",
    """DROP TABLE OrderHeadOld""",
    """DROP TABLE OrderListOld""",
    """DROP TABLE ${DatabaseConstants.customerTable}"""
  ];

  static final _secondMigration = [
    """ALTER TABLE ${DatabaseConstants.memoTable} RENAME TO MemoOld""",
    """CREATE TABLE ${DatabaseConstants.memoTable} (
            ${DatabaseConstants.memoID}	INTEGER NOT NULL,
            ${DatabaseConstants.isMemoEdited}	INTEGER,
            ${DatabaseConstants.memoContent}	TEXT,
            ${DatabaseConstants.memoCateID}	INTEGER,
            FOREIGN KEY(${DatabaseConstants.memoCateID}) REFERENCES ${DatabaseConstants.categoriesTable}(${DatabaseConstants.cateID}) ON DELETE SET NULL,
            PRIMARY KEY(${DatabaseConstants.memoID})
          );
          """,
    """INSERT INTO ${DatabaseConstants.memoTable} (${DatabaseConstants.memoID}, ${DatabaseConstants.isMemoEdited}, ${DatabaseConstants.memoContent}, ${DatabaseConstants.memoCateID})
    SELECT ${DatabaseConstants.memoID}, 0, ${DatabaseConstants.memoContent}, ${DatabaseConstants.memoCateID}
    FROM MemoOld"""
  ];
}
