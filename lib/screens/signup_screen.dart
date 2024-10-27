import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _professionalExpController = TextEditingController();
  final _referenceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedGender = 'Male';
  String _selectedServiceType = 'Massage Therapist';

  final List<String> _genders = ['Male', 'Female', 'Other'];

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    // Verify if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Call the sign-up API
    bool success = await _apiService.signup(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      ccode: '91', // Replace as needed
      mobile: _mobileController.text,
      gender: _selectedGender,
      serviceType: _selectedServiceType,
      professionalExp: _professionalExpController.text,
      reference: _referenceController.text,
      udp: '1', // Replace as needed
      auth: '123456', // Replace as needed
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Show success popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Your account has been created successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard',
                    arguments:
                        _emailController.text, // Pass the email as an argument
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Show error if sign-up failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/app_login_bg.PNG',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "XJW Mobile Massage - Practitioner",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Signup",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildTextInput(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _mobileController,
                    hintText: 'Mobile No.',
                    icon: Icons.phone,
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(height: 10),
                  _buildGenderSelector(),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _professionalExpController,
                    hintText: 'Professional Experience',
                    icon: Icons.business_center,
                  ),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _referenceController,
                    hintText: 'Reference Code (if any)',
                    icon: Icons.code,
                  ),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  SizedBox(height: 10),
                  _buildTextInput(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _signUp,
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Already have an account? Log In",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: inputType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _genders.map((gender) {
            return Expanded(
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(gender, style: TextStyle(color: Colors.black)),
                value: gender,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value.toString();
                  });
                },
                activeColor: Colors.red,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
