import 'db_provider.dart';

class DatabaseMigrationScripts {
  static final migrationScripts = [_firstMigration];

  static final _firstMigration = [
    """ALTER TABLE ${DbProvider.orderHeadTable} RENAME TO OrderHeadOld""",
    """ALTER TABLE ${DbProvider.orderListTable} RENAME TO OrderListOld""",
    """CREATE TABLE ${DbProvider.orderHeadTable} (
            ${DbProvider.orderID}	INTEGER NOT NULL,
            ${DbProvider.payType}	TEXT NOT NULL,
            ${DbProvider.soldTo}	TEXT,
            ${DbProvider.total}	REAL NOT NULL,
            ${DbProvider.date} TEXT NOT NULL,
            PRIMARY KEY(${DbProvider.orderID})
          );
          """,
    """CREATE TABLE ${DbProvider.orderListTable} (
            ${DbProvider.orderListId} INTEGER NOT NULL,
            ${DbProvider.orderID}	INTEGER NOT NULL,
            ${DbProvider.itemID}	INTEGER NOT NULL,
            ${DbProvider.listPrice}	REAL NOT NULL,
            ${DbProvider.qty}	INTEGER NOT NULL,
            PRIMARY KEY(${DbProvider.orderListId})
            FOREIGN KEY(${DbProvider.orderID}) REFERENCES ${DbProvider.orderHeadTable}(${DbProvider.orderID}) ON DELETE CASCADE,
            FOREIGN KEY(${DbProvider.itemID}) REFERENCES ${DbProvider.catalogTable}(${DbProvider.itemID}) ON DELETE CASCADE
          )""",
    """INSERT INTO ${DbProvider.orderHeadTable} (${DbProvider.orderID}, ${DbProvider.payType}, ${DbProvider.total}, ${DbProvider.date})
    SELECT ${DbProvider.orderID}, ${DbProvider.payType}, ${DbProvider.total}, ${DbProvider.date}
    FROM OrderHeadOld""",
    """INSERT INTO ${DbProvider.orderListTable} (${DbProvider.orderID}, ${DbProvider.itemID}, ${DbProvider.listPrice}, ${DbProvider.qty})
    SELECT ${DbProvider.orderID}, ${DbProvider.itemID}, ${DbProvider.listPrice}, ${DbProvider.qty}
    FROM OrderListOld""",
    """DROP TABLE OrderHeadOld""",
    """DROP TABLE OrderListOld""",
    """DROP TABLE ${DbProvider.customerTable}"""
  ];
}
