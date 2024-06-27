import 'package:flutter/material.dart';

class SaleProductWidget extends StatelessWidget {
  const SaleProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 139,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/images/khmer_food.webp",
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 22,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(7)),
                ),
                child: Center(
                  child: Text(
                    '5.00\$',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text('ឡាបសាច់គោបែបខ្មែរ'),
            ),
          ),
        ],
      ),
    );
  }
}
