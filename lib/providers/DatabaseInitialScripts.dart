import '../core/constants/database_constants.dart';
import '../core/local_database_helper.dart';

class DatabaseInitialScript {
  static final initialScripts = [
    _createCategoriesTable,
    _createCatalogTable,
    _createOrderHeadTable,
    _createOrderListTable,
    _createMemoTable
  ];

  static final _createCategoriesTable = """
          CREATE TABLE ${DatabaseConstants.categoriesTable} (
            ${DatabaseConstants.cateID}	INTEGER NOT NULL,
            ${DatabaseConstants.cateName} TEXT NOT NULL UNIQUE,
            PRIMARY KEY(${DatabaseConstants.cateID})
          );
          """;

  static final _createCatalogTable = """
          CREATE TABLE ${DatabaseConstants.catalogTable} (
            ${DatabaseConstants.itemID}	INTEGER NOT NULL,
            ${DatabaseConstants.itemName} TEXT NOT NULL UNIQUE,
            ${DatabaseConstants.itemPrice} REAL NOT NULL,
            PRIMARY KEY(${DatabaseConstants.itemID})
          );
          """;

  static final _createOrderHeadTable = """
          CREATE TABLE ${DatabaseConstants.orderHeadTable} (
            ${DatabaseConstants.orderID}	INTEGER NOT NULL,
            ${DatabaseConstants.payType}	TEXT NOT NULL,
            ${DatabaseConstants.soldTo}	TEXT,
            ${DatabaseConstants.total}	REAL NOT NULL,
            ${DatabaseConstants.date} TEXT NOT NULL,
            PRIMARY KEY(${DatabaseConstants.orderID})
          );
          """;

  static final _createOrderListTable = """
          CREATE TABLE ${DatabaseConstants.orderListTable} (
            ${DatabaseConstants.orderListId} INTEGER NOT NULL,
            ${DatabaseConstants.orderID}	INTEGER NOT NULL,
            ${DatabaseConstants.itemID}	INTEGER NOT NULL,
            ${DatabaseConstants.listPrice}	REAL NOT NULL,
            ${DatabaseConstants.qty}	INTEGER NOT NULL,
            PRIMARY KEY(${DatabaseConstants.orderListId})
            FOREIGN KEY(${DatabaseConstants.orderID}) REFERENCES ${DatabaseConstants.orderHeadTable}(${DatabaseConstants.orderID}) ON DELETE CASCADE,
            FOREIGN KEY(${DatabaseConstants.itemID}) REFERENCES ${DatabaseConstants.catalogTable}(${DatabaseConstants.itemID}) ON DELETE CASCADE
          );
          """;

  static final _createMemoTable = """
          CREATE TABLE ${DatabaseConstants.memoTable} (
            ${DatabaseConstants.memoID}	INTEGER NOT NULL,
            ${DatabaseConstants.isMemoEdited}	INTEGER,
            ${DatabaseConstants.memoContent}	TEXT,
            ${DatabaseConstants.memoCateID}	INTEGER,
            FOREIGN KEY(${DatabaseConstants.memoCateID}) REFERENCES ${DatabaseConstants.categoriesTable}(${DatabaseConstants.cateID}) ON DELETE SET NULL,
            PRIMARY KEY(${DatabaseConstants.memoID})
          );
          """;
}
