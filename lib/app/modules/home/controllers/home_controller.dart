import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../models/model_transaction.dart'; // Adjust path as per your project structure

class HomeController extends GetxController {
  var transactions = <TransactionData>[].obs;

  // TextEditingControllers for managing text inputs
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  var isEditing = false.obs;
  var editingIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is disposed
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void fetchTransactions() {
    var sampleData = {
      "list_data": [
        {"rowid": 1, "Name": "bibin", "Description": "abcd", "Amount": 10.0},
        {"rowid": 2, "Name": "ajith", "Description": "asdfgh", "Amount": 10.0},
        {"rowid": 3, "Name": "anas", "Description": "qwerty", "Amount": 10.0},
        {"rowid": 4, "Name": "jewel", "Description": "lmnop", "Amount": 10.0}
      ]
    };

    var transactionModel = TransactionModel.fromJson(sampleData);
    transactions.value = transactionModel.listData ?? [];
  }

  void addTransaction() {
    transactions.add(TransactionData(
      rowid: transactions.length + 1,
      name: nameController.text,
      description: descriptionController.text,
      amount: double.tryParse(amountController.text) ?? 0.0,
    ));
    clearFields();
  }

  void editTransaction() {
    if (editingIndex.value >= 0) {
      transactions[editingIndex.value] = TransactionData(
        rowid: transactions[editingIndex.value].rowid,
        name: nameController.text,
        description: descriptionController.text,
        amount: double.tryParse(amountController.text) ?? 0.0,
      );
      clearFields();
      isEditing.value = false;
      editingIndex.value = -1;
    }
  }

  void deleteTransaction(int index) {
    transactions.removeAt(index);
  }

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
    amountController.clear();
  }

  void startEditing(int index) {
    editingIndex.value = index;
    var transaction = transactions[index];
    nameController.text = transaction.name ?? '';
    descriptionController.text = transaction.description ?? '';
    amountController.text = transaction.amount?.toString() ?? '';
    isEditing.value = true;
  }

  void exportToExcel() async {
    try {
      // Create a new Excel workbook
      final Workbook workbook = Workbook();

      // Accessing the first worksheet in the workbook
      final Worksheet sheet = workbook.worksheets[0];
      sheet.name = 'Transactions';

      // Adding header row
      sheet.getRangeByIndex(1, 1).setText('Sl.No');
      sheet.getRangeByIndex(1, 2).setText('Name');
      sheet.getRangeByIndex(1, 3).setText('Description');
      sheet.getRangeByIndex(1, 4).setText('Amount');

      // Adding data rows
      int rowIndex = 2;
      for (var transaction in transactions) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(transaction.rowid.toString());
        sheet.getRangeByIndex(rowIndex, 2).setText(transaction.name ?? '');
        sheet
            .getRangeByIndex(rowIndex, 3)
            .setText(transaction.description ?? '');
        sheet.getRangeByIndex(rowIndex, 4).setNumber(transaction.amount ?? 0.0);
        rowIndex++;
      }

      // Auto-fit columns based on content
      for (int colIndex = 1; colIndex <= 4; colIndex++) {
        sheet.autoFitColumn(colIndex);
      }

      // Save the workbook
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose(); // Dispose the workbook to free resources

      // Get the downloads directory
      final downloadsDirectory = await getDownloadsDirectory();
      final DateTime now = DateTime.now();
      final String filename = "transactions_${now.toIso8601String()}.xlsx";
      final String filePath = '${downloadsDirectory!.path}/$filename';
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      print(filePath);
      Get.snackbar("Success", "Excel file saved at $filePath");
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Failed to save Excel file: $e");
    }
  }
}
