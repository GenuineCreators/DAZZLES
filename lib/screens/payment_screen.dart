import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
// ignore: unused_import
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:customers/widgets/bottom_navbar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotification();
  }

  void initializeNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,
      'Firebase Messaging',
      'You have paid successfully and you have placed a new order ',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void userTapped() {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm Payment"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Card Number: $cardNumber"),
                Text("Expiry Date: $expiryDate"),
                Text("Card Holder name: $cardHolderName"),
                Text("CVV: $cvvCode"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showNotification();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(),
                  ),
                );
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Payment",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // credit card
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),
            CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
              formKey: formKey,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 350,
              child: ElevatedButton(
                onPressed: () async {
                  userTapped();
                },
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}





















// import 'package:customers/widgets/bottom_navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({
//     super.key,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;

//   void userTapped() {
//     if (formKey.currentState!.validate()) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text("Confirm Payment"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 Text("Card Number: $cardNumber"),
//                 Text("Expiry Date: $expiryDate"),
//                 Text("Card Holder name: $cardHolderName"),
//                 Text("CVV: $cvvCode"),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BottomNavBar(),
//                 ),
//               ),
//               child: Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel"),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         foregroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(
//           "Payment",
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // credit card
//             CreditCardWidget(
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               showBackView: isCvvFocused,
//               onCreditCardWidgetChange: (p0) {},
//             ),
//             CreditCardForm(
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               onCreditCardModelChange: (data) {
//                 setState(() {
//                   cardNumber = data.cardNumber;
//                   expiryDate = data.expiryDate;
//                   cardHolderName = data.cardHolderName;
//                   cvvCode = data.cvvCode;
//                 });
//               },
//               formKey: formKey,
//             ),
//             SizedBox(height: 40),
//             SizedBox(
//               width: 350,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   userTapped();
//                 },
//                 child: Text(
//                   'Pay Now',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.0,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }
