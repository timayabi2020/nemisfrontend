import 'package:flutter/material.dart';
import 'package:techhackportal/screens/login/login_screen.dart';

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() => _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedGender;

  Future<void> _fetchStudentDetailsByUPI() async {
    final upi = _upiController.text.trim();
    if (upi.isEmpty) return;

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _firstNameController.text = "John";
      _middleNameController.text = "Kamau";
      _lastNameController.text = "Mwangi";
      _selectedGender = "Male";
      _dobController.text = "2010-06-15";
      _nationalityController.text = "Kenyan";
      _emailController.text = "john.mwangi@example.com";
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Student registration submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  Future<void> _pickDateOfBirth() async {
    DateTime initialDate = DateTime.tryParse(_dobController.text) ?? DateTime(2010);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/maasai_mara.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.green.withOpacity(0.7),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _upiController,
                                  decoration: const InputDecoration(
                                    labelText: 'Unique Personal Identifier (UPI)',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty ? 'UPI is required' : null,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search, color: Colors.white),
                                onPressed: _fetchStudentDetailsByUPI,
                                tooltip: "Fetch details",
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'First name is required' : null,
                          ),
                          TextFormField(
                            controller: _middleNameController,
                            decoration: const InputDecoration(
                              labelText: 'Middle Name',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Last name is required' : null,
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: ['Male', 'Female']
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedGender = value),
                          ),
                          GestureDetector(
                            onTap: _pickDateOfBirth,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _dobController,
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _nationalityController,
                            decoration: const InputDecoration(
                              labelText: 'Nationality',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Email is required';
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              return emailRegex.hasMatch(value) ? null : 'Invalid email';
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Submit'),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                                                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );// or navigate to login screen
                            },
                            child: const Text('Already have an account? Login'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}