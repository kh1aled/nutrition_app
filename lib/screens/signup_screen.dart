import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_validation_indicator.dart';
import '../widgets/custom_button.dart';
import '../utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Password validation states
  bool _hasMinLength = false;
  bool _containsNumber = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update validation indicators in real-time
    _passwordController.addListener(_updatePasswordValidation);
    _confirmPasswordController.addListener(_updatePasswordValidation);
  }

  void _updatePasswordValidation() {
    setState(() {
      _hasMinLength = Validators.hasMinLength(_passwordController.text);
      _containsNumber = Validators.containsNumber(_passwordController.text);
      _passwordsMatch = Validators.passwordsMatch(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('Success!'),
              ],
            ),
            content: const Text('Account created successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _clearForm() {
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _formKey.currentState?.reset();
  }

  void _navigateToLogin() {
    // Navigate to login screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login screen would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E4F3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE5E5E5),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const Expanded(
                            child: Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40), // Balance the back button
                        ],
                      ),
                    ),

                    // Form content
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Text(
                              'Join the community',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter your details to get started.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Email field
                            CustomTextField(
                              label: 'Email Address',
                              hintText: 'alex@example.com',
                              controller: _emailController,
                              validator: Validators.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),

                            // Phone field
                            CustomTextField(
                              label: 'Phone Number',
                              hintText: '+1 (555) 000-0000',
                              controller: _phoneController,
                              validator: Validators.validatePhone,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+\-\s\(\)]'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Password field
                            CustomTextField(
                              label: 'Password',
                              hintText: '••••••••',
                              controller: _passwordController,
                              validator: Validators.validatePassword,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF7C3AED),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Confirm Password field
                            CustomTextField(
                              label: 'Confirm Password',
                              hintText: '••••••••',
                              controller: _confirmPasswordController,
                              validator: (value) => Validators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                              obscureText: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF7C3AED),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password validation indicators
                            PasswordValidationIndicator(
                              isValid: _hasMinLength,
                              text: 'At least 8 characters',
                            ),
                            const SizedBox(height: 8),
                            PasswordValidationIndicator(
                              isValid: _containsNumber,
                              text: 'Contains a number',
                            ),
                            const SizedBox(height: 8),
                            PasswordValidationIndicator(
                              isValid: _passwordsMatch,
                              text: 'Passwords match',
                            ),
                            const SizedBox(height: 32),

                            // Sign Up button
                            CustomButton(
                              text: 'Sign Up',
                              onPressed: _handleSignUp,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: 20),

                            // Login link
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _navigateToLogin,
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF7C3AED),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Terms and Privacy
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  children: const [
                                    TextSpan(text: 'By signing up, you agree to our '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: Color(0xFF7C3AED),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Color(0xFF7C3AED),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
