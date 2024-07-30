import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/pages/home_page.dart';
import 'package:coffeeapp/provider/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/cart_tile.dart';
import '../components/my_button.dart';
import '../model/coffee.dart';


/*

CART PAGE

  - User can check their cart and remove items if necessary
  - User can tap 'Pay now' button $

*/

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // delete item from cart
  void removeItemFromCart(String id) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('cart').doc(id).delete();
  }

  // pay now button tapped
  void payNow(AsyncValue<QuerySnapshot<Object?>> cartData) {
    cartData.maybeWhen(
      data: (data) {
        // Loop through each cart item and delete it from Firestore
        data.docs.forEach((item) {
          removeItemFromCart(item.id);
        });

        String msg = "Thank you for your order!";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
        ));

        // Optionally, you can navigate back to the home page or any other page after payment
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      },
      orElse: () {}, // Handle other cases if necessary
    ); // Replace '/' with your main page route
    }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var cartData = ref.watch(cartDataProvider);
      double totalPrice = 0; // Initialize total price variable
      return Column(
        children: [
          // heading
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0, top: 25, bottom: 25),
                child: Text(
                  'Your Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),

          cartData.when(
              data: (data) {
                // Calculate total price
                totalPrice = data.docs.fold<double>(
                  0,
                        (previousValue, doc) => previousValue + (double.parse(doc['price'] ?? '0') ?? 0),
                );
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      // get individual cart items
                      Coffee coffee = Coffee(name: data.docs[index]['name'], price: data.docs[index]['price'], imagePath: data.docs[index]['image'],category: data.docs[index]['category'],);

                      return CartTile(
                        coffee: coffee,
                        category: data.docs[index]['category'],
                        onPressed: () => removeItemFromCart(data.docs[index].id),
                      );
                    },
                  ),
                );
              },
              error: (e, r) => Text(e.toString()),
              loading: () => const SizedBox.shrink()),
          // Total
          Text(
            'Total: Rs ${totalPrice.toStringAsFixed(2)}', // Format total price with two decimal places
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // pay button
          MyButton(text: "Your Order will be here soon!",
            onTap: () => payNow(cartData))
        ],
      );
    });
  }
}
