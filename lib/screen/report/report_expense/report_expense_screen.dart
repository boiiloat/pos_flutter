import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class ReportExpanseScreen extends StatelessWidget {
  const ReportExpanseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // fake data
    final expenses = [
      {
        "ref": "#SN-000001",
        "description": "ជួសជុលម៉ាស៊ីនត្រជាក់",
        "amount": "\$20.00",
        "method": "ABA",
        "createdBy": "leam loat",
        "createdDate": "01/07/2025",
        "note": "ជួសជុលត្រជាក់ខូច"
      },
      {
        "ref": "#SN-000002",
        "description": "ទិញគ្រឿងទេស",
        "amount": "\$1600.00",
        "method": "Cash",
        "createdBy": "leam loat",
        "createdDate": "03/07/2025",
        "note": "ទិញគ្រឿងទេសថ្មី"
      },
      {
        "ref": "#SN-000003",
        "description": "ទិញកាហ្វេប៉ោត",
        "amount": "\$10.00",
        "method": "ABA",
        "createdBy": "leam loat",
        "createdDate": "05/07/2025",
        "note": "សម្រាប់បង្ហាត់បារ"
      },
      {
        "ref": "#SN-000004",
        "description": "ជួសជុលសម្ភារៈ",
        "amount": "\$40.00",
        "method": "ABA",
        "createdBy": "leam loat",
        "createdDate": "10/07/2025",
        "note": "ជួសជុលបន្ទប់ទឹក"
      },
      {
        "ref": "#SN-000005",
        "description": "Service maintenance",
        "amount": "\$30.00",
        "method": "ABA",
        "createdBy": "leam loat",
        "createdDate": "12/07/2025",
        "note": "ថែទាំប្រចាំខែ"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SNACK & RELAX CAFE',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: appColor,
      ),
      body: Column(
        children: [
          // Header row
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {
                // add new expense action
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Expense"),
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Center(child: Text("Ref."))),
                Expanded(flex: 3, child: Center(child: Text("Description"))),
                Expanded(flex: 2, child: Center(child: Text("Amount"))),
                Expanded(flex: 2, child: Center(child: Text("Payment method"))),
                Expanded(flex: 2, child: Center(child: Text("Created by"))),
                Expanded(flex: 2, child: Center(child: Text("Created date"))),
                Expanded(flex: 3, child: Center(child: Text("Note"))),
              ],
            ),
          ),
          const Divider(height: 1),
          // Data rows
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final item = expenses[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2, child: Center(child: Text(item["ref"]!))),
                      Expanded(
                          flex: 3,
                          child: Center(child: Text(item["description"]!))),
                      Expanded(
                          flex: 2, child: Center(child: Text(item["amount"]!))),
                      Expanded(
                          flex: 2, child: Center(child: Text(item["method"]!))),
                      Expanded(
                          flex: 2,
                          child: Center(child: Text(item["createdBy"]!))),
                      Expanded(
                          flex: 2,
                          child: Center(child: Text(item["createdDate"]!))),
                      Expanded(
                          flex: 3, child: Center(child: Text(item["note"]!))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
