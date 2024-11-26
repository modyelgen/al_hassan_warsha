import 'package:al_hassan_warsha/core/utils/functions/conver_en_to_ar.dart';
import 'package:al_hassan_warsha/core/utils/functions/data_base_helper.dart';
import 'package:al_hassan_warsha/features/financial_workshop/data/models/salary_model.dart';
import 'package:al_hassan_warsha/features/financial_workshop/data/models/transaction_model.dart';
import 'package:al_hassan_warsha/features/financial_workshop/data/repos/financial_repo.dart';
import 'package:al_hassan_warsha/features/management_workshop/data/models/constants.dart';
import 'package:al_hassan_warsha/features/management_workshop/data/models/order_model.dart';
import 'package:al_hassan_warsha/features/management_workshop/data/models/pill_model.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

class FinancialRepoImpl implements FinancialRepo {
  final DataBaseHelper dataBaseHelper;
  FinancialRepoImpl({required this.dataBaseHelper});

// create transaction table name
//     await dataBaseHelper.database.execute('''
// CREATE TABLE $transactionTableName (
//     transactionId TEXT PRIMARY KEY,
//     transactionName TEXT NOT NULL,
//     transactionAmount TEXT NOT NULL,
//     transactionType INTEGER NOT NULL,
//     transactionMethod INTEGER NOT NULL,
//     transactionTime TEXT NOT NULL,
//     transactionAllTypes INTEGER NOT NULL DEFAULT 5
// );
// ''');
  @override
  Future<Either<(List<OrderModel>, int), String>> getAllBills(
      {int? offset, int? optionPaymentWay}) async {
    try {
      String whereClause = optionPaymentWay != null
          ? "orderId = ? AND optionPaymentWay = ?"
          : "orderId = ?";

      final result = await dataBaseHelper.database.query(
        orderTableName,
        limit: 8,
        offset: offset,
      );
      List<OrderModel> orderList = [];
      for (var item in result) {
        final whereArgs = optionPaymentWay != null
            ? [item['orderId'], optionPaymentWay]
            : [item['orderId']];
        final pillresult = await dataBaseHelper.database.query(
          pillTableName,
          where: whereClause,
          whereArgs: whereArgs,
        );
        if (pillresult.isNotEmpty) {
          PillModel pillModel = PillModel.fromJson(pillresult.first);
          OrderModel orderModel = OrderModel.fromJson(item);
          orderModel.pillModel = pillModel;
          orderList.add(orderModel);
        }
      }

      int? totalLength = await getTableCount(orderTableName) ?? 0;

      return left((orderList, totalLength));
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<PillModel, String>> downStep(String pillId, String remainAmount,
      String orderName, String payedAmount) async {
    try {
      if (double.parse(remainAmount) > 1) {
        await dataBaseHelper.database.rawUpdate(
          '''
  UPDATE $pillTableName
  SET stepsCounter = stepsCounter - 1, remainMoney = ?
  WHERE pillId = ?
  ''',
          [remainAmount, pillId],
        );
      } else {
        await dataBaseHelper.database.rawUpdate(
          '''
  UPDATE $pillTableName
  SET stepsCounter = ?, remainMoney = ?
  WHERE pillId = ?
  ''',
          [0, remainAmount, pillId],
        );
      }
      final result = await dataBaseHelper.database
          .query(pillTableName, where: 'pillId = ?', whereArgs: [pillId]);

      await addTransaction(
          model: TransactionModel(
              transactionId: const Uuid().v4(),
              transactionAmount: payedAmount,
              transactionMethod: TransactionMethod.caching,
              allTransactionTypes: AllTransactionTypes.stepDown,
              transactionTime: DateTime.now(),
              transactionType: TransactionType.recieve,
              transactionName: " دفعة "));
      return left(PillModel.fromJson(result.first));
    } catch (e) {
      return right(e.toString());
    }
  }

  Future<int?> getTableCount(String tableName) async {
    try {
      // Query to count rows in the specific table
      final result = await dataBaseHelper.database
          .rawQuery("SELECT COUNT(*) as count FROM $tableName");
      return result.first['count'] != null ? result.first['count'] as int : 0;
      // Extract the count or return 0 if null
    } catch (e) {
      // Handle error, optionally log or throw
      return 0;
    }
  }

  @override
  Future<Either<List<OrderModel>, String>> searchForOrder(
      {required String searchKeyWord, required String parameterSearch}) async {
    try {
      String searchPattern = '%$searchKeyWord%';
      String columnToSearch;
      switch (parameterSearch) {
        case 'customerName':
          columnToSearch = 'c.customerName';
          break;
        case 'orderName':
          columnToSearch = 'o.orderName';
          break;
        default:
          throw ArgumentError('Invalid search parameter: $parameterSearch');
      }

      // Execute the SQL query for the specific column
      final List<Map<String, dynamic>> results =
          await dataBaseHelper.database.rawQuery('''
    SELECT o.*
    FROM $orderTableName o
    LEFT JOIN $customerTableName c ON o.customerId = c.customerId
    WHERE $columnToSearch LIKE ?
  ''', [searchPattern]);
      List<OrderModel> searchedList = [];
      for (var item in results) {
        PillModel pillModel = PillModel();
        final result = await dataBaseHelper.database.query(pillTableName,
            where: 'orderId = ?', whereArgs: [item['orderId']]);
        pillModel = PillModel.fromJson(result.first);
        searchedList.add(OrderModel(
            orderId: item['orderId'],
            pillModel: pillModel,
            orderName: item['orderName']));
      }
      return left(searchedList);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<TransactionModel, String>> addTransaction(
      {required TransactionModel model}) async {
    try {
      await dataBaseHelper.database
          .insert(transactionTableName, model.toJson());

      final result = await dataBaseHelper.database.query(transactionTableName,
          where: 'transactionId = ?', whereArgs: [model.transactionId]);
      return left(TransactionModel.fromJson(result.first));
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<TransactionModel>, String>> getAllTransaction(
      {required int month, required int year}) async {
    try {
      String monthString =
          month.toString().padLeft(2, '0'); // Ensure 2-digit format
      String yearString = year.toString();
      List<TransactionModel> transactionList = [];
      final transactionResult = await dataBaseHelper.database.query(
          transactionTableName,
          where:
              "strftime('%Y', transactionTime) = ? AND strftime('%m', transactionTime) = ?",
          whereArgs: [yearString, monthString]);
      for (var item in transactionResult) {
        transactionList.add(TransactionModel.fromJson(item));
      }
      return left(transactionList);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<bool, String>> removeTransation({required String id}) async {
    try {
      await dataBaseHelper.database.delete(transactionTableName,
          where: "transactionId = ?", whereArgs: [id]);
      return left(true);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<bool, String>> removeWorker(String workerId) async {
    try {
      await dataBaseHelper.database.delete(workersTableName,
          where: 'workerId = ?', whereArgs: [workerId]);
      return left(true);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<bool, String>> editWorkersData(
      List<WorkerModel> addedList, List<WorkerModel> editedList) async {
    try {
      if (addedList.isNotEmpty) {
        for (var item in addedList) {
          await dataBaseHelper.database
              .insert(workersTableName, item.toAddJson());
        }
      }
      if (editedList.isNotEmpty) {
        for (var item in editedList) {
          await dataBaseHelper.database.update(workersTableName, item.toJson(),
              where: "workerId = ?", whereArgs: [item.workerId]);
        }
      }
      return left(true);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<WorkerModel>, String>> getAllWokersData() async {
    try {
//       await dataBaseHelper.database.execute('''
// CREATE TABLE Workers (
//     workerId TEXT PRIMARY KEY,
//     workerName TEXT NOT NULL,
//     workerPhone TEXT,
//     salaryType INTEGER NOT NULL DEFAULT 2,
//     salaryAmount TEXT NOT NULL DEFAULT '0',
//     lastAddedSalary TEXT
// );
// ''');
      final result = await dataBaseHelper.database.query(workersTableName);
      List<WorkerModel> workersList = [];
      if (result.isNotEmpty) {
        for (var item in result) {
          workersList.add(WorkerModel.fromJson(item));
        }
      }
      return left(workersList);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<bool, String>> payTheSalary(
      List<WorkerModel> workerList) async {
    try {
      int totalAmount = 0;
      for (var item in workerList) {
        totalAmount += int.parse(convertToEnglishNumbers(item.salaryAmount));
        await dataBaseHelper.database.rawUpdate(
            '''UPDATE $workersTableName SET lastAddedSalary = ?  WHERE workerId = ?''',
            [
              DateTime.now().toIso8601String(),
              item.workerId,
            ]);
      }
      await dataBaseHelper.database.insert(
          transactionTableName,
          TransactionModel(
                  transactionId: const Uuid().v4(),
                  transactionAmount: totalAmount.toString(),
                  transactionMethod: TransactionMethod.caching,
                  allTransactionTypes: AllTransactionTypes.salaries,
                  transactionTime: DateTime.now(),
                  transactionType: TransactionType.buy,
                  transactionName: " مرتبات ")
              .toJson());

      return left(true);
    } catch (e) {
      return right(e.toString());
    }
  }
}
