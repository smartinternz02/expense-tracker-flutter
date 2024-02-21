// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_app/models/dtos/base.dto.dart';

class ExpenseCategoryDTO extends BaseDTO {
  int? id;
  String? name;
  int? iconPoint;
  String? createdOn;
  String? updatedOn;

  ExpenseCategoryDTO({
    this.id,
    this.name,
    this.iconPoint,
    this.createdOn,
    this.updatedOn,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': id,
      'Name': name,
      'IconPoint': iconPoint,
      'Createdon': updatedOn,
      'UpdatedOn': updatedOn,
    };
  }

  @override
  String getTableName() {
    return 'ExpenseCategory';
  }

  factory ExpenseCategoryDTO.fromMap(Map<String, dynamic> map) {
    return ExpenseCategoryDTO(
      id: map['Id'],
      name: map['Name'],
      iconPoint: map['IconPoint'],
      createdOn: map['Createdon'],
      updatedOn: map['UpdatedOn'],
    );
  }
}
