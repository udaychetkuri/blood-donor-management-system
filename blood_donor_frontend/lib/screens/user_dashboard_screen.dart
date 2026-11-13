
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();

  bool isLoading = false;
  List<dynamic> donorResults = [];
  bool hasSearched = false;

  Future<void> searchDonors() async {
    final city = cityController.text.trim().toLowerCase();
    final bloodGroup = bloodGroupController.text.trim().toUpperCase();

    if (city.isEmpty || bloodGroup.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter both city and blood group')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    try {
      // Backend lo /api/donors/search ledu, anduke /api/users nundi anni techi, ikkade filter chestunnam
      final response = await http.get(Uri.parse(
        'http://localhost:3000/api/users',
      ));

      if (response.statusCode == 200) {
        final List<dynamic> allUsers = jsonDecode(response.body);
        final filtered = allUsers.where((user) {
          final userCity = (user['city'] ?? '').toString().toLowerCase();
          final userBlood = (user['bloodGroup'] ?? '').toString().toUpperCase();
          return userCity == city && userBlood == bloodGroup;
        }).toList();

        setState(() => donorResults = filtered);

        if (filtered.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No donors found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No donors found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget donorTable() {
    if (!hasSearched) {
      return const Text('Search to see donors.');
    }
    if (donorResults.isEmpty) {
      return const Text('No donors found.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Blood Group')),
          DataColumn(label: Text('City')),
          DataColumn(label: Text('Phone')),
          DataColumn(label: Text('Email')),
        ],
        rows: donorResults.map((donor) {
          return DataRow(
            cells: [
              DataCell(Text(donor['name'] ?? '')),
              DataCell(Text(donor['bloodGroup'] ?? '')),
              DataCell(Text(donor['city'] ?? '')),
              // Backend lo 'contact' kadu, 'phone' undi
              DataCell(Text(donor['phone'] ?? donor['contact'] ?? '')),
              DataCell(Text(donor['email'] ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Search Donors', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bloodGroupController,
              decoration: const InputDecoration(labelText: 'Blood Group'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : searchDonors,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Search'),
            ),
            const SizedBox(height: 20),
            donorTable(),
          ],
        ),
      ),
    );
  }
}