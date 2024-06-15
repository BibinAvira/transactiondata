import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:transactiondata/app/modules/home/models/model_transaction.dart';
import '../controllers/home_controller.dart'; // Adjust import path as per your project structure

class SfDataGridWidget extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfDataGrid(
        key: UniqueKey(), // Ensure key is added for refreshing the grid
        allowPullToRefresh: true,
        verticalScrollPhysics: BouncingScrollPhysics(),
        horizontalScrollPhysics: BouncingScrollPhysics(),
        defaultColumnWidth: Get.width / 5,
        allowColumnsResizing: true,
        source: _DataSource(controller.transactions.toList(), controller),
        columnWidthMode: ColumnWidthMode.fill,
        headerRowHeight: 40, // Customize as needed
        columns: <GridColumn>[
          GridColumn(
            minimumWidth: Get.width * 0.15,
            maximumWidth: Get.width * 0.15,
            columnName: 'rowid',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.blue, // Change header background color
              ),
              child: Text(
                'Sl.No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change header text color
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          GridColumn(
            minimumWidth: Get.width * 0.17,
            maximumWidth: Get.width * 0.17,
            columnName: 'name',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.blue, // Change header background color
              ),
              child: Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change header text color
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          GridColumn(
            minimumWidth: Get.width * 0.17,
            maximumWidth: Get.width * 0.19,
            columnName: 'description',
            label: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue, // Change header background color
              ),
              child: Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change header text color
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          GridColumn(
            minimumWidth: Get.width * 0.17,
            maximumWidth: Get.width * 0.17,
            columnName: 'amount',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.blue, // Change header background color
              ),
              child: Text(
                'Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change header text color
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          // Actions column
          GridColumn(
            minimumWidth: Get.width * 0.17,
            maximumWidth: Get.width * 0.24,
            columnName: 'actions',
            label: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue, // Change header background color
              ),
              child: Text(
                'Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change header text color
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _DataSource extends DataGridSource {
  final List<TransactionData> transactions;
  final HomeController controller;

  _DataSource(this.transactions, this.controller);

  @override
  List<DataGridRow> get rows => transactions
      .asMap()
      .entries
      .map<DataGridRow>((entry) => DataGridRow(
            cells: [
              DataGridCell<int>(
                columnName: 'rowid',
                value: entry.key + 1, // Row index starts from 1
              ),
              DataGridCell<String>(
                columnName: 'name',
                value: entry.value.name ?? '',
              ),
              DataGridCell<String>(
                columnName: 'description',
                value: entry.value.description ?? '',
              ),
              DataGridCell<double>(
                columnName: 'amount',
                value: entry.value.amount ?? 0.0,
              ),
              DataGridCell<int>(
                columnName: 'actions',
                value: entry.key, // Pass the index as value for actions column
              ),
            ],
          ))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final List<Widget> cells = row.getCells().map<Widget>((cell) {
      final value = cell.value;
      final columnName = cell.columnName;

      // Build actions column
      if (columnName == 'actions') {
        return Container(
          alignment: Alignment.center,
          child: _buildActionsRow(value as int), // Cast value to int
        );
      }

      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(value != null ? value.toString() : ''),
      );
    }).toList();

    return DataGridRowAdapter(
      cells: cells,
    );
  }

  Widget _buildActionsRow(int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            if (rowIndex >= 0 && rowIndex < transactions.length) {
              controller.startEditing(rowIndex);
            } else {
              Get.snackbar('Error', 'Invalid index for editing');
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if (rowIndex >= 0 && rowIndex < transactions.length) {
              controller.deleteTransaction(rowIndex);
            } else {
              Get.snackbar('Error', 'Invalid index for deleting');
            }
          },
        ),
      ],
    );
  }
}
