import 'package:flutter/material.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/pos/sale/widgets/sale_payment_button_widget.dart';
import 'package:pos_system/screen/pos/sale/widgets/sale_type_payment_widget.dart';

class SalaPaymentWidget extends StatelessWidget {
  const SalaPaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.red,
            child: Center(
                child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            )),
          ),
        ),
        Expanded(
          flex: 9,
          child: Container(
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SaleTypePaymentWidget(
                              icon: Icon(Icons.payments),
                              label: 'Cash Payment',
                              paymentType: 'cash_payment', // Unique identifier
                            ),
                            SaleTypePaymentWidget(
                              icon: Icon(Icons.credit_card),
                              label: 'ABA Bank',
                              paymentType: 'aba_bank', // Unique identifier
                            ),
                            SaleTypePaymentWidget(
                              icon: Icon(Icons.credit_card),
                              label: 'AC Bank',
                              paymentType: 'ac_bank', // Unique identifier
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Text(
                        "Total Pay :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 80),
                      Text(
                        '\$ 9.00',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 50),
                      Text(
                        '៛​ 36,000',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Text(
                        'Cash Riel :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 35),
                      Container(
                        width: 260,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Riel',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Text(
                        'Cash Dollar :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 260,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Dollar',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      Text(
                        'Cash balance :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Text(
                        '\$ 1.00',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SalePaymentButtonWidget(
                  color: Colors.red,
                  label: 'Payment With Print',
                  icon: Icon(Icons.print),
                  onPressed: () {
                    Program.alert("title", "description");
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: SalePaymentButtonWidget(
                  label: 'Payment',
                  color: Colors.red,
                  icon: Icon(Icons.monetization_on),
                  onPressed: () {
                    Program.alert("title", "description");
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
