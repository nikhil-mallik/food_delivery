import 'package:flutter/material.dart';
// import 'package:food_app/widget/widget_support.dart';

import '../wiget/widget_support.dart';

class Details extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String price;

  // You can pass these values to the Details screen
  const Details({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
            ),
            // Image for the food item
            Image.network(
              widget.imageUrl, // Dynamic image passed from the previous screen
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 15.0),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mediterranean", style: AppWidget.semiboldTextFeildStyle()),
                    Text(widget.name, style: AppWidget.boldTextFeildStyle()),  // Dynamically using the name passed from the previous screen
                  ],
                ),
                const Spacer(),
                // Decrease Quantity Button
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20.0),
                Text(quantity.toString(), style: AppWidget.semiboldTextFeildStyle()),
                const SizedBox(width: 20.0),
                // Increase Quantity Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Description of the item
            Text(
              widget.description,  // Dynamically using the description passed from the previous screen
              maxLines: 3,
              style: AppWidget.LightTextFeildStyle(),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text("Delivery Time", style: AppWidget.semiboldTextFeildStyle()),
                const SizedBox(width: 20.0),
                const Icon(Icons.alarm, color: Colors.black54),
                const SizedBox(width: 20.0),
                Text("30 min", style: AppWidget.semiboldTextFeildStyle()),
              ],
            ),
            const Spacer(),
            // Total Price Calculation and Add to Cart Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Price", style: AppWidget.semiboldTextFeildStyle()),
                      Text("\$${(double.parse(widget.price) * quantity).toStringAsFixed(2)}", style: AppWidget.HeadlineTextFeildStyle()), // Calculating total price dynamically
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Add to cart",
                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(width: 40.0),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey, borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
