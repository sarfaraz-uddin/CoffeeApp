import 'package:coffeeapp/provider/coffee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/coffee_tile.dart';
import '../model/coffee.dart';
import 'coffee_order_page.dart';

/*

SHOP PAGE

User can browse the coffees that are for sale

*/

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // coffee page
  String selectedCategory = 'All'; // Default selected category

  void setSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }
  void goToCoffeePage(Coffee coffee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoffeeOrderPage(
          coffee: coffee,
        ),
      ),
    );
  }

  // void goToCoffeePage(Coffee coffee) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CoffeeOrderPage(
  //         coffee: coffee,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var coffeeData = ref.watch(coffeeDataProvider);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category selection
          // DropdownButton<String>(
          //   value: selectedCategory,
          //   onChanged: (String? newValue) {
          //     if (newValue != null) {
          //       setSelectedCategory(newValue);
          //     }
          //   },
          //   items: <String>['All','hot', 'cold', 'chicken','buff','veg','buritto'] // Add your categories here
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          // heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                Icon(Icons.category, color: Colors.grey),
                SizedBox(width: 10),
                Text(
                  'Category:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setSelectedCategory(newValue);
                    }
                  },
                  items: <String>['All', 'drinks', 'chicken', 'buff', 'veg', 'snacks', 'Desserts']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(), // Remove the underline
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25.0, top: 25),
            child: Text(
              'Restaurant Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // list of coffee
        Flexible(
          child:coffeeData.when(
              data: (data) {
                List<DocumentSnapshot> filteredCoffees = selectedCategory == 'All'
                    ? data.docs // Display all coffees if 'All' is selected
                    : data.docs.where((doc) {
                  final docData = doc.data();
                  return docData is Map<String, dynamic> &&
                      docData.containsKey('category') &&
                      docData['category'] == selectedCategory;
                }).toList();
                // Filter coffees by selected category
                return ListView.builder(
                  // itemCount: data.docs.length,
                  itemCount: filteredCoffees.length,
                  itemBuilder: (context, index) {
                    final docData = filteredCoffees[index].data(); // Nullable map
                    // get individual coffee
                    // String name = data.docs[index]['name'];
                    // String image = data.docs[index]['image'];
                    // String price = data.docs[index]['price'];
                    if(docData is Map<String,dynamic>) {
                      String name = docData['name'] as String;
                      String image = docData['image'] as String;
                      String price = docData['price'] as String;

                      return CoffeeTile(
                        name: name,
                        image: image,
                        price: price,
                        onPressed: () =>
                            goToCoffeePage(Coffee(
                                name: name, price: price, imagePath: image)),
                      );
                    }else{
                      return SizedBox.shrink();
                    }
                  },
                );
              },
              error: (e, r) => Text(e.toString()),
              loading: () => const SizedBox.shrink()),
        ),
      ],
      );
    });
  }
}
