import 'package:expense_app/models/dtos/base.dto.dart';
import 'package:expense_app/utils/date_extensions.dart';

class UserDTO extends BaseDTO {
  String? name;
  String? userName;
  String? password;
  DateTime? createdOn;
  DateTime? updatedOn;

  UserDTO({
    this.name,
    this.userName,
    this.password,
    this.createdOn,
    this.updatedOn,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'userName': userName,
      'password': password,
      'createdOn': createdOn?.getYYYMMDDHHmmssFormat(),
      'updatedOn': updatedOn?.getYYYMMDDHHmmssFormat(),
    };
  }

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      name: map['name'] != null ? map['name'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      createdOn: map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      updatedOn: map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  @override
  String getTableName() {
    return 'User';
  }
}
