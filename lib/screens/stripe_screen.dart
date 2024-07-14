// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// class StripeScreen extends StatefulWidget {
//   const StripeScreen({super.key});

//   @override
//   State<StripeScreen> createState() => _StripeScreenState();
// }

// class _StripeScreenState extends State<StripeScreen> {
//   Map<String, dynamic>? paymentIntent;

//   Future<void> makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent();
//       var gpay = const PaymentSheetGooglePay(
//         merchantCountryCode: "US",
//         currencyCode: "USD",
//         testEnv: true,
//       );
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent!["client_secret"],
//           style: ThemeMode.dark,
//           merchantDisplayName: "Benja",
//           googlePay: gpay,
//         ),
//       );
//       await displayPaymentSheet();
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<void> displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment successful')),
//       );
//     } catch (e) {
//       if (e is StripeException) {
//         print("Error from Stripe: ${e.error.localizedMessage}");
//       } else {
//         print("Unforeseen error: $e");
//       }
//     }
//   }

//   Future<Map<String, dynamic>> createPaymentIntent() async {
//     try {
//       Map<String, dynamic> body = {
//         "amount": "1000",
//         "currency": "USD",
//         "payment_method_types[]": "card",
//       };

//       http.Response response = await http.post(
//         Uri.parse("https://api.stripe.com/v1/payment_intents"),
//         body: body,
//         headers: {
//           "Authorization":
//               "Bearer sk_test_51Pc3ygGZhbE8wHICDsj1RHy31h5nv24ReXCAuStPAmFgi3870GwtA8GPlKEQYB4Vprq0fH8gqtpGKaf2l4ujIHcD007LM8xMwv",
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//       );
//       return json.decode(response.body);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stripe Example"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             makePayment();
//           },
//           child: Text("Pay Now"),
//         ),
//       ),
//     );
//   }
// }

















// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// class StripeScreen extends StatefulWidget {
//   const StripeScreen({super.key});

//   @override
//   State<StripeScreen> createState() => _StripeScreenState();
// }

// Map<String, dynamic>? paymentIntent;

// void makePayment() async {
//   try {
//     paymentIntent = await createPaymentIntent();
//     var gpay = const PaymentSheetGooglePay(
//       merchantCountryCode: "US",
//       currencyCode: "USD",
//       testEnv: true,
//     );
//     await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//       paymentIntentClientSecret: paymentIntent!["client_secret"],
//       style: ThemeMode.dark,
//       merchantDisplayName: "Benja",
//       googlePay: gpay,
//     ));
//     displayPaymentSheet();
//   } catch (e) {
//     print("failed");
//   }
// }

// void displayPaymentSheet() async {
//   try {
//     await Stripe.instance.presentPaymentSheet();
//     print("Done");
//   } catch (e) {
//     print("Failed");
//   }
// }

// createPaymentIntent() async {
//   try {
//     Map<String, dynamic> body = {
//       "amount": "1000",
//       "currency": "USD",
//     };

//     http.Response response = await http.post(
//         Uri.parse("https://api.stripe.com/v1/payment_intents"),
//         body: body,
//         headers: {
//           "Authorization":
//               "Bearer sk_test_51Pc3ygGZhbE8wHICDsj1RHy31h5nv24ReXCAuStPAmFgi3870GwtA8GPlKEQYB4Vprq0fH8gqtpGKaf2l4ujIHcD007LM8xMwv",
//           "Content-Type": "application/x-www-form-urlencoded",
//         });
//     return json.decode(response.body);
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// }

// class _StripeScreenState extends State<StripeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stripe Example"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             makePayment();
//           },
//           child: Text("Pay Now"),
//         ),
//       ),
//     );
//   }
// }
