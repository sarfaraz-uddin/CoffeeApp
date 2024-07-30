import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/*

COFFEE TILE

This is the tile seen on the shop page.
User can add to cart by tapping the tile.

*/

class CoffeeTile extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  void Function()? onPressed;
  CoffeeTile({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    // Parse the price string to double and handle any parsing errors
    double priceValue = double.tryParse(price) ?? 0.0;

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
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: ListTile(
        leading: Container(
          width: 50,
            child: Image.network(image,fit: BoxFit.cover,)),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(formattedPrice),
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.brown[300],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
