import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchText = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by name or location...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('companies').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Filtered list based on search text
        List<DocumentSnapshot> filteredList =
            snapshot.data!.docs.where((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String name = data['name'].toString().toLowerCase();
          String location = data['location'].toString().toLowerCase();

          return name.contains(_searchText) || location.contains(_searchText);
        }).toList();

        if (filteredList.isEmpty) {
          return Center(child: Text('No results found.'));
        }

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = filteredList[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return CompanyCard(
              companyId: document.id,
              imageUrl: data['imageUrl'],
              name: data['name'],
              transportfee: data['transportFee'],
              arrivalTime: data['arrivalTime'],
              location: data['location'],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchInput(),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }
}
