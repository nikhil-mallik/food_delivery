// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// class WalletPage extends StatefulWidget {
//   const WalletPage({super.key});

//   @override
//   _WalletPageState createState() => _WalletPageState();
// }

// class _WalletPageState extends State<WalletPage> {
//   String walletBalance = "120"; // Initial wallet balance
//   Map<String, dynamic>? paymentIntent;

//   // Your Stripe secret key (replace with your actual key)
//   final String secretKey = 'sk_test_...';

//   @override
//   void initState() {
//     super.initState();
//     Stripe.publishableKey = 'pk_test_...'; // Your Stripe publishable key
//   }

//   Future<void> makePayment(String amount) async {
//     try {
//       paymentIntent = await createPaymentIntent(amount, 'INR');
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent!['client_secret'],
//           merchantDisplayName: 'My Store',
//         ),
//       );
//       await displayPaymentSheet(amount);
//     } catch (e) {
//       print('Error in payment: $e');
//     }
//   }

//   Future<void> displayPaymentSheet(String amount) async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       setState(() {
//         walletBalance = (int.parse(walletBalance) + int.parse(amount)).toString();
//       });

//       // Show success dialog
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("Payment Successful"),
//           content: Text("Rs $amount has been added to your wallet."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("OK"),
//             )
//           ],
//         ),
//       );

//       paymentIntent = null;
//     } catch (e) {
//       print('Payment canceled or error occurred: $e');
//     }
//   }

//   Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer $secretKey',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: body,
//       );
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('Error creating payment intent: $err');
//       return {};
//     }
//   }

//   String calculateAmount(String amount) {
//     final calculatedAmount = (int.parse(amount)) * 100; // Convert to smallest currency unit
//     return calculatedAmount.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wallet'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Wallet balance section
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(color: Colors.grey[200]),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Your Wallet", style: TextStyle(fontSize: 18)),
//                   Text("Rs $walletBalance", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text("Your Money", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 amountButton("100"),
//                 amountButton("200"),
//                 amountButton("300"),
//                 amountButton("400"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget amountButton(String amount) {
//     return ElevatedButton(
//       onPressed: () {
//         makePayment(amount);
//       },
//       child: Text("Rs $amount"),
//     );
//   }
// }
