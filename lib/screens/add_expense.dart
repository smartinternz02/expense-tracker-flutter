import 'package:expense_app/models/expense.model.dart';
import 'package:expense_app/services/expenses/expense.service.dart';
import 'package:expense_app/shared/widgets/date_picker.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;
  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  bool isEditMode = false;
  late Expense expense;
  late ExpenseService _expenseService;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _expenseService = ExpenseService();
    if (widget.expense != null) {
      expense = widget.expense!;
      isEditMode = true;
    } else {
      expense = Expense();
      expense.expenseDate = DateTime.now();
      expense.categoryId = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
        actions: isEditMode
            ? [
                IconButton(
                    onPressed: () {
                      showConfirmDelete();
                    },
                    icon: const Icon(Icons.delete))
              ]
            : null,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: _buildForm(),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () {}, child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();

                  if (expense.id == null) {
                    var id = await _expenseService.addExpense(expense);
                    if (id > 0) {
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                      // Fluttertoast.showToast(msg: "Expense added successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
                    }
                  } else {
                    if (await _expenseService.updateExpense(expense)) {
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpenseDatePicker(
                onDateSelected: (selectedDate) {
                  expense.expenseDate = selectedDate;
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: expense.amount != null ? '${expense.amount}' : null,
                  onSaved: (value) {
                    expense.amount = double.parse(value!);
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter valid amount';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Enter Amount', hintStyle: TextStyle(fontSize: 22)),
                  style: const TextStyle(height: 3, fontSize: 22),
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    initialValue: expense.name,
                    onSaved: (title) {
                      expense.name = title!;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter title';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Title', border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))),
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    initialValue: expense.note,
                    onSaved: (note) {
                      expense.note = note;
                    },
                    maxLines: null,
                    decoration: const InputDecoration(hintText: 'Note', border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1))),
                  )),
            ],
          ),
        ));
  }

  void showConfirmDelete() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text(
              'Are you sure to delete the expense ?',
              style: TextStyle(fontSize: 16),
            ),
            title: const Text('Confirm Delete ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('cancel')),
              FilledButton(
                  onPressed: () async {
                    if (await _expenseService.deleteExpense(expense.id!)) {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: const Text('Confirm'))
            ],
          );
        });
  }
}
