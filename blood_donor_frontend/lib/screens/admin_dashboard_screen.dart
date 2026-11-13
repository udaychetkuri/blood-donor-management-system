import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<dynamic> donors = [];
  String bloodGroup = '';
  String city = '';
  bool loading = false;

  Future<void> fetchDonors() async {
    setState(() => loading = true);
    final url = Uri.parse('http://localhost:3000/api/donors/search?bloodGroup=$bloodGroup&city=$city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        donors = json.decode(response.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch donors')),
      );
    }
  }

  Future<void> exportToCSV() async {
    if (await Permission.storage.request().isGranted) {
      final rows = [
        ['Name', 'Age', 'Blood Group', 'Contact', 'City', 'Email'],
        ...donors.map((d) => [
          d['name'],
          d['age'].toString(),
          d['bloodGroup'],
          d['contact'],
          d['city'],
          d['email']
        ])
      ];

      String csvData = const ListToCsvConverter().convert(rows);
      final directory = await getExternalStorageDirectory();
      final path = "${directory!.path}/donors.csv";
      final file = File(path);
      await file.writeAsString(csvData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV saved to $path')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Blood Group'),
              onChanged: (value) => bloodGroup = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'City'),
              onChanged: (value) => city = value,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchDonors,
              child: const Text('Search Donors'),
            ),
            const SizedBox(height: 10),
            loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: donors.isEmpty
                        ? const Text('No donors found.')
                        : Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: donors.length,
                                  itemBuilder: (context, index) {
                                    final d = donors[index];
                                    return ListTile(
                                      title: Text('${d['name']} (${d['bloodGroup']})'),
                                      subtitle: Text('${d['city']} - ${d['contact']}'),
                                    );
                                  },
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: exportToCSV,
                                icon: const Icon(Icons.download),
                                label: const Text('Download CSV'),
                              )
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
