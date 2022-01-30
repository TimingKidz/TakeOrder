import 'db_provider.dart';

class DatabaseInitialScript {
  static final initialScripts = [
    _createCategoriesTable,
    _createCatalogTable,
    _createOrderHeadTable,
    _createOrderListTable,
    _createMemoTable
  ];

  static final _createCategoriesTable = """
          CREATE TABLE ${DbProvider.categoriesTable} (
            ${DbProvider.cateID}	INTEGER NOT NULL,
            ${DbProvider.cateName} TEXT NOT NULL UNIQUE,
            PRIMARY KEY(${DbProvider.cateID})
          );
          """;

  static final _createCatalogTable = """
          CREATE TABLE ${DbProvider.catalogTable} (
            ${DbProvider.itemID}	INTEGER NOT NULL,
            ${DbProvider.itemName} TEXT NOT NULL UNIQUE,
            ${DbProvider.itemPrice} REAL NOT NULL,
            PRIMARY KEY(${DbProvider.itemID})
          );
          """;

  static final _createOrderHeadTable = """
          CREATE TABLE ${DbProvider.orderHeadTable} (
            ${DbProvider.orderID}	INTEGER NOT NULL,
            ${DbProvider.payType}	TEXT NOT NULL,
            ${DbProvider.soldTo}	TEXT,
            ${DbProvider.total}	REAL NOT NULL,
            ${DbProvider.date} TEXT NOT NULL,
            PRIMARY KEY(${DbProvider.orderID})
          );
          """;

  static final _createOrderListTable = """
          CREATE TABLE ${DbProvider.orderListTable} (
            ${DbProvider.orderListId} INTEGER NOT NULL,
            ${DbProvider.orderID}	INTEGER NOT NULL,
            ${DbProvider.itemID}	INTEGER NOT NULL,
            ${DbProvider.listPrice}	REAL NOT NULL,
            ${DbProvider.qty}	INTEGER NOT NULL,
            PRIMARY KEY(${DbProvider.orderListId})
            FOREIGN KEY(${DbProvider.orderID}) REFERENCES ${DbProvider.orderHeadTable}(${DbProvider.orderID}) ON DELETE CASCADE,
            FOREIGN KEY(${DbProvider.itemID}) REFERENCES ${DbProvider.catalogTable}(${DbProvider.itemID}) ON DELETE CASCADE
          );
          """;

  static final _createMemoTable = """
          CREATE TABLE ${DbProvider.memoTable} (
            ${DbProvider.memoID}	INTEGER NOT NULL,
            ${DbProvider.isMemoEdited}	INTEGER,
            ${DbProvider.memoContent}	TEXT,
            ${DbProvider.memoCateID}	INTEGER,
            FOREIGN KEY(${DbProvider.memoCateID}) REFERENCES ${DbProvider.categoriesTable}(${DbProvider.cateID}) ON DELETE SET NULL,
            PRIMARY KEY(${DbProvider.memoID})
          );
          """;
}
