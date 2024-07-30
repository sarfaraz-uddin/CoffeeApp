import 'package:flutter/material.dart';
import '../model/coffee.dart';
import 'package:intl/intl.dart';

/*

CART TILE

This is the tile seen on the coffee order page.
User can remove from cart by tapping the tile.


*/

class CartTile extends StatelessWidget {
  final Coffee coffee;
  final String? category;
  void Function()? onPressed;
  CartTile({
    super.key,
    required this.coffee,
    this.category,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the price string to double and handle any parsing errors
    double priceValue = double.tryParse(coffee.price) ?? 0.0;

    // // Format the price in Nepali Rupees format
    // String formattedPrice = NumberFormat.currency(locale: 'ne_NP', symbol: 'रू').format(priceValue);
    // Format the price in English Rupees format
    String formattedPrice = NumberFormat.currency(symbol: 'Rs ').format(priceValue);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        leading: Container(
          width: 50,
            child: Image.network(coffee.imagePath,fit: BoxFit.cover)),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coffee.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (category != null) // Display category if available
                Text(
                  'Category: $category',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
        ),
        subtitle: Text(formattedPrice),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.brown[300],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
