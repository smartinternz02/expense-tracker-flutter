import 'package:expense_app/models/category.model.dart';
import 'package:expense_app/models/dtos/expense_category.dto.dart';
import 'package:expense_app/services/database/app_database.dart';
import 'package:expense_app/utils/date_extensions.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryService {
  static List<IconData> sampleIcons = [
    Icons.home,
    Icons.access_alarm,
    Icons.ac_unit,
    Icons.shop,
    Icons.pest_control,
    Icons.flight,
    Icons.card_giftcard_outlined,
    Icons.flight,
    Icons.accessibility_sharp,
    Icons.account_balance,
    Icons.account_balance_wallet_sharp,
    Icons.blinds_closed_outlined,
    Icons.mobile_friendly,
    Icons.computer_outlined,
    Icons.electric_bike,
    Icons.comment,
    Icons.bed,
    Icons.devices_other_sharp,
    Icons.more
  ];
  Future<int> addCategory(ExpenseCategory expenseCategory) {
    var expenseCategoryDTO = ExpenseCategoryDTO();
    expenseCategoryDTO.name = expenseCategory.name;
    expenseCategoryDTO.iconPoint = expenseCategory.iconPoint;
    expenseCategoryDTO.createdOn = DateTime.now().getYYYMMDDHHmmssFormat();
    expenseCategoryDTO.updatedOn = DateTime.now().getYYYMMDDHHmmssFormat();

    return AppDatabase.insert<ExpenseCategoryDTO>(expenseCategoryDTO);
  }

  Future<bool> updateCategory(ExpenseCategory expenseCategory) {
    var expenseCategoryDTO = ExpenseCategoryDTO();
    expenseCategoryDTO.id = expenseCategory.id;
    expenseCategoryDTO.name = expenseCategory.name;
    expenseCategoryDTO.iconPoint = expenseCategory.iconPoint;
    expenseCategoryDTO.updatedOn = DateTime.now().getYYYMMDDHHmmssFormat();

    return AppDatabase.update<ExpenseCategoryDTO>(expenseCategoryDTO, whereQuery: "Id = ${expenseCategoryDTO.id}");
  }

  Future<List<ExpenseCategory>> getCategories() async {
    var expenseCategoriesMap = await AppDatabase.get('ExpenseCategory');
    var result = expenseCategoriesMap!.map((map) => ExpenseCategoryDTO.fromMap(map)).map((e) {
      var expenseCategory = ExpenseCategory();
      expenseCategory.id = e.id;
      expenseCategory.name = e.name!;
      expenseCategory.iconPoint = e.iconPoint!;

      return expenseCategory;
    }).toList();

    return result;
  }

  Future<bool> deleteCategory(int id) {
    return AppDatabase.delete('Expense', where: 'Id = $id');
  }
}
