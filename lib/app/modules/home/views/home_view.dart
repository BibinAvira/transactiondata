import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:transactiondata/app/modules/home/views/sfgrid_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.isEditing.value) {
                          controller.editTransaction();
                        } else {
                          controller.addTransaction();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets
                            .zero, // Remove padding to make the button fit the container
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Set borderRadius to 0 for square shape
                        ),
                      ),
                      child: Obx(() => Text(
                            controller.isEditing.value ? 'Edit' : 'Add',
                            style: TextStyle(fontSize: 15),
                          )),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.clearFields,
                      child: const Text(
                        'Clear',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets
                            .zero, // Remove padding to make the button fit the container
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Set borderRadius to 0 for square shape
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      height: 50,
                      child: IconButton(
                        onPressed: controller.exportToExcel,
                        icon: Icon(Icons
                            .download), // Replace Icons.download with your desired icon
                        tooltip:
                            'Export to Excel', // Optional tooltip for accessibility
                      ),
                    ),
                  ),
                ],
              ),
              SfDataGridWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
