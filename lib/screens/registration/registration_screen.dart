import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:techhackportal/config.dart';
import 'package:techhackportal/screens/login/login_screen.dart';

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedGender = 'Male';
  String noStudentFound = "No student found with this UPI";

  bool _isLoading = false;

  bool showError = false;
  bool fetchSuccess = false;

  Future<void> _fetchStudentDetailsByUPI() async {
    final upi = _upiController.text.trim();
    if (upi.isEmpty) return;

    setState(() {
      _isLoading = true;
      showError = false;
    });

    final url =
        "$NEMIS_URI/$upi";

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
          )
          .timeout(const Duration(seconds: 40));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded != null) {
          setState(() {
            _firstNameController.text = decoded['fullName']['firstName'] ?? '';
            _middleNameController.text =
                decoded['fullName']['middleName'] ?? '';
            _lastNameController.text = decoded['fullName']['lastName'] ?? '';
            _selectedGender = decoded['gender'] ?? 'Male';
            _dobController.text = decoded['dateOfBirth'] ?? '';
            _nationalityController.text = decoded['nationality'] ?? '';
            _isLoading = false;
            fetchSuccess = true;
          });
        } else {
          setState(() {
            showError = true;
            _isLoading = false;
            _firstNameController.text = '';
            _middleNameController.text = '';
            _lastNameController.text = '';
            _selectedGender = 'Male';
            _dobController.text = '';
            _nationalityController.text = '';
            fetchSuccess = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          showError = true;
          _firstNameController.text = '';
          _middleNameController.text = '';
          _lastNameController.text = '';
          _selectedGender = 'Male';
          _dobController.text = '';
          _nationalityController.text = '';
          fetchSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        showError = true;
        _isLoading = false;
        _firstNameController.text = '';
        _middleNameController.text = '';
        _lastNameController.text = '';
        _selectedGender = 'Male';
        _dobController.text = '';
        _nationalityController.text = '';
        fetchSuccess = false;
      });
    }
  }

  void _submitForm(BuildContext context) {

    if (_formKey.currentState!.validate() && !showError) {
      final studentData = {
        'username': _upiController.text.trim(),
        'email': _emailController.text.trim(),
        'student_id': _upiController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      // Here you would typically send the studentData to your backend API
//Call your API to register the student


      final url = Uri.parse(REGISTRATION);
      http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(studentData),
      ).then((response) {
        var decodedResponse = jsonDecode(response.body);
        if (response.statusCode == 201) {
          _showSuccessDialog("Student registration submitted successfully.", "Success");
        } else {
          Navigator.of(context).pop(); // Close the loading dialog
          // Handle error response
          var errorMessage = decodedResponse['student_id'][0] ?? 'Registration failed';
          _showSuccessDialog(errorMessage, "Fail");
        }
      }).catchError((error) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      });

      // showDialog(
      //   context: context,
      //   builder:
      //       (context) => AlertDialog(
      //         title: const Text('Success'),
      //         content: const Text('Student registration submitted.'),
      //         actions: [
      //           TextButton(
      //             onPressed: () => Navigator.of(context).pop(),
      //             child: const Text('OK'),
      //           ),
      //         ],
      //       ),
      // );
    }
  }

  Future<void> _pickDateOfBirth() async {
    DateTime initialDate =
        DateTime.tryParse(_dobController.text) ?? DateTime(2010);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/maasai_mara.png', fit: BoxFit.cover),
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
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          key: const ValueKey('registration_form'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _upiController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration(
                                      'Unique Personal Identifier (UPI)',
                                    ),
                                    validator:
                                        (value) =>
                                            value == null || value.isEmpty
                                                ? 'UPI is required'
                                                : null,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: _fetchStudentDetailsByUPI,
                                  tooltip: "Fetch details",
                                ),
                              ],
                            ),
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const SizedBox.shrink(),

                            showError
                                ? Text(
                                  'No student found with this UPI',
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 16.0,
                                  ),
                                )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _firstNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('First Name'),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'First name is required'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _middleNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Middle Name'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _lastNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Last Name'),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Last name is required'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: _inputDecoration('Gender'),
                              dropdownColor: Colors.green.shade700,
                              items:
                                  ['Male', 'Female']
                                      .map(
                                        (gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text(
                                            gender,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => _selectedGender = value!),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickDateOfBirth,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _dobController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Date of Birth'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nationalityController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Nationality'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Email Address'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex = RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                );
                                return emailRegex.hasMatch(value)
                                    ? null
                                    : 'Invalid email';
                              },
                            ),
                            const SizedBox(height: 16),
                                                        TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Password'),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Password is required'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Confirm Password'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password is required';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            if (fetchSuccess) ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white70,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    buildShowdialog(context);
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,

                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
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
  buildShowdialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(

        content: Row(
          children: [
CircularProgressIndicator(color: Colors.white,),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Registering user..."),
            ),
          ],
        ),
      ),
    );
    //_loginUser(context);
    _submitForm(context);
  }
  void _showSuccessDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content:Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
