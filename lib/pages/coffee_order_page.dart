import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/pages/edit_page.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_chip.dart';
import '../const.dart';
import '../model/coffee.dart';

/*

COFFEE ORDER PAGE

User can select the quantity and size of their coffee order.
User can 'Add to cart' on this page

*/

class CoffeeOrderPage extends StatefulWidget {
  final Coffee coffee;
  const CoffeeOrderPage({super.key, required this.coffee});

  @override
  State<CoffeeOrderPage> createState() => _CoffeeOrderPageState();
}

class _CoffeeOrderPageState extends State<CoffeeOrderPage> {
  // quantity of order
  int quantity = 1;

  // increment quantity
  void increment() {
    setState(() {
      // max out at 10
      if (quantity < 10) {
        quantity++;
      }
    });
  }

  // decrement quantity
  void decrement() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  // current size selection (only one can be selected)
  final List<bool> _sizeSelection = [
    // small
    true,

    // medium
    false,

    // large
    false,
  ];

  // select size
  void selectSize(String size) {
    setState(() {
      switch (size) {
        case 'S':
          {
            _sizeSelection[0] = true;
            _sizeSelection[1] = false;
            _sizeSelection[2] = false;
          }
          break;
        case 'M':
          {
            _sizeSelection[0] = false;
            _sizeSelection[1] = true;
            _sizeSelection[2] = false;
          }
          break;
        case 'L':
          {
            _sizeSelection[0] = false;
            _sizeSelection[1] = false;
            _sizeSelection[2] = true;
          }
          break;
      }
    });
  }

  // add to cart
  void addToCart(String? category) async {
    if (quantity > 0) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      // Calculate price based on selected size
      int price = 0;
      if (_sizeSelection[0]) {
        // Small size
        price = quantity * int.parse(widget.coffee.price);
      } else if (_sizeSelection[1]) {
        // Medium size
        price = quantity * int.parse(widget.coffee.price) * 2; // Example: double the price for medium
      } else if (_sizeSelection[2]) {
        // Large size
        price = quantity * int.parse(widget.coffee.price) * 3; // Example: triple the price for large
      }

      await firebaseFirestore.collection('cart').doc().set(
        {"name": widget.coffee.name, "image": widget.coffee.imagePath, "price": price.toString(),"category":category},
      );

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            "Successfully added to cart",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[900],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(coffee: widget.coffee)));
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // coffee image
              Image.network(
                widget.coffee.imagePath,
                height: 120,
              ),

              const SizedBox(height: 50),

              // quantity
              Column(
                children: [
                  // heading
                  Text(
                    widget.coffee.name.toUpperCase(),
                    style: const TextStyle(color: Colors.grey, fontSize: 20, letterSpacing: 2.3),
                  ),
                  const SizedBox(height: 15),
                  // counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // decrement
                      IconButton(
                        onPressed: decrement,
                        icon: const Icon(Icons.remove),
                        color: Colors.grey,
                      ),

                      // count
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 60,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),

                      // icrement
                      IconButton(
                        onPressed: increment,
                        icon: const Icon(Icons.add),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // size
              const Text(
                "S I Z E",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // small
                  GestureDetector(
                    onTap: () => selectSize('S'),
                    child: MyChip(text: 'S', isSelected: _sizeSelection[0]),
                  ),

                  const SizedBox(width: 4),

                  // medium
                  GestureDetector(
                    onTap: () => selectSize('M'),
                    child: MyChip(text: 'M', isSelected: _sizeSelection[1]),
                  ),

                  const SizedBox(width: 4),

                  // large
                  GestureDetector(
                    onTap: () => selectSize('L'),
                    child: MyChip(text: 'L', isSelected: _sizeSelection[2]),
                  ),
                ],
              ),

              const SizedBox(height: 75),

              // add to cart button
              MyButton(text: "Add to cart", onTap:() => addToCart(widget.coffee.category)),
            ],
          ),
        ),
      ),
    );
  }
}
