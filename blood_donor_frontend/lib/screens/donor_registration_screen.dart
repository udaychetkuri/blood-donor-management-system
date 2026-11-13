import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonorRegistrationScreen extends StatefulWidget {
  final String token;

  DonorRegistrationScreen({required this.token});

  @override
  _DonorRegistrationScreenState createState() => _DonorRegistrationScreenState();
}

class _DonorRegistrationScreenState extends State<DonorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String message = '';

  Future<void> registerDonor() async {
    final url = Uri.parse('http://localhost:3000/api/donors');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
      body: jsonEncode({
        'name': nameController.text,
        'age': int.parse(ageController.text),
        'bloodGroup': bloodGroupController.text,
        'contact': contactController.text,
        'city': cityController.text,
        'email': emailController.text,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        message = 'Donor registered successfully!';
      });
      _formKey.currentState?.reset();
    } else {
      setState(() {
        message = 'Failed to register donor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register as Donor')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Name', nameController),
              buildTextField('Age', ageController, isNumber: true),
              buildTextField('Blood Group (e.g. A+)', bloodGroupController),
              buildTextField('Contact', contactController),
              buildTextField('City', cityController),
              buildTextField('Email', emailController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerDonor,
                child: Text('Submit'),
              ),
              SizedBox(height: 10),
              Text(message, style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}

