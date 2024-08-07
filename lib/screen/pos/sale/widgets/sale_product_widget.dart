import 'package:flutter/material.dart';

class SaleProductWidget extends StatelessWidget {
  final String imageUrl;
  final String productPrice;
  final String productName;

  const SaleProductWidget({
    Key? key,
    required this.imageUrl,
    required this.productPrice,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 147,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl) // Load image from URL
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
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
                child: Center(
                  child: Text(
                    productPrice,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 25,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                productName,
                style: const TextStyle(fontSize: 12), // Example style
              ),
            ),
          ),
        ],
      ),
    );
  }
}
