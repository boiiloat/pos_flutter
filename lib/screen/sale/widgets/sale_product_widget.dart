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
      height: 120,
      width: 153,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  : Text('fuck me'), // Placeholder if imageUrl is empty or null
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 22,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(7),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      productPrice,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
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
              child: Text(
                productName,
                style: TextStyle(fontSize: 12), // Adjust font size as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
