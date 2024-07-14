import 'package:flutter/material.dart';

class MyDeliveryBox extends StatelessWidget {
  final Widget transportfee;
  final Widget arrivalTime;
  const MyDeliveryBox({
    super.key,
    required this.transportfee,
    required this.arrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          transportfee,
          arrivalTime,
        ],
      ),
    );
  }
}
