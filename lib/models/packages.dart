// ignore_for_file: constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

class Package {
  final String name;
  final String description;
  final String imagePath;
  final String price;

  Package({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
  });
}

// late
// CompanyCard companyCard;



// enum Category {
//   External,
//   Internal,
//   full,
//   Polish,
// }

// class Package extends StatelessWidget {
//   final String name;
//   final String description;
//   final String imagePath;
//   final String price;
//   const Package(
//       {super.key,
//       required this.name,
//       required this.description,
//       required this.imagePath,
//       required this.price});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {},
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [Text(name), Text(price), Text(description)],
//                       ),
//                     ),
//                     Image.network(
//                       imagePath,
//                       height: 80,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
