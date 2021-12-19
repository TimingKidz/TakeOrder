import 'db_provider.dart';

class DatabaseMigrationScripts {
  static final migrationScripts = [_firstMigration];

  static final _firstMigration = [
    """ALTER TABLE ${DbProvider.orderListTable} RENAME TO OrderListOld""",
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
    """INSERT INTO ${DbProvider.orderListTable} (${DbProvider.orderID}, ${DbProvider.itemID}, ${DbProvider.listPrice}, ${DbProvider.qty})
    SELECT ${DbProvider.orderID}, ${DbProvider.itemID}, ${DbProvider.listPrice}, ${DbProvider.qty}
    FROM OrderListOld""",
    """DROP TABLE OrderListOld"""
  ];
}
