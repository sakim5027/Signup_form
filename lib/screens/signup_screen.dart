import 'package:flutter/material.dart';

void main() {
  runApp(const SignupScreen());
}

// 🧓 Great-Grandparent
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordMatchController =
      TextEditingController();

  // Fixed category for Signup Tip
  static const String _tipCategory = 'password_help';

  // Preset tips stored locally inside the app.
  static const Map<String, List<String>> _localTips = {
    'password_help': [
      'Use a longer than 6 characters, unique password for each account.',
      'Avoid using your birthday or common words in passwords.',
      'Make sure to update your password regularly.',
      'Consider using a mix of letters, numbers, and symbols for passwords.',
    ],
  };

  String _tipMessage = 'Click for tips';
  int _tipIndex = 0;

  Future<void> _getSignupTip() async {
    setState(() {
      _tipMessage = '';
    });

    // Simulate loading for one second.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Fixed category: password_help
    final tips = _localTips[_tipCategory];

    if (tips != null && tips.isNotEmpty) {
      setState(() {
        _tipMessage = tips[_tipIndex % tips.length];
        _tipIndex++;
      });
    } else {
      setState(() {});
    }
  }

  bool _obscurePassword = true;
  DateTime? _birthDate;
  final _dateController = TextEditingController();
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true); // potion starts brewing

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // user may have left the screen

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // 👶 Child
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // 👤 Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _dateController,
                  readOnly: true, // taps open the picker, not the keyboard
                  decoration: const InputDecoration(
                    labelText: 'Birth Date',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  validator: (_) =>
                      _birthDate == null ? 'Pick your birth date' : null,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2008),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(), // no future birthdays!
                    );
                    if (picked != null) {
                      setState(() {
                        _birthDate = picked;
                        _dateController.text =
                            '${picked.month}/${picked.day}/${picked.year}';
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 📧 Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 🔒 Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🔒 Password Check Field
                TextFormField(
                  controller: _passwordMatchController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the password again';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 🚀 Sign Up Button
                ElevatedButton(
                  onPressed: _submitting ? null : _submit, // null = disabled
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Join the Mansion',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                const SizedBox(height: 20),

                // tip button
                ElevatedButton(
                  onPressed: _getSignupTip,
                  child: const Text('Local AI Demo Tips'),
                ),

                const SizedBox(height: 10),

                // Display selected tip
                if (_tipMessage.isNotEmpty)
                  Text(
                    'Local AI demo tip: $_tipMessage',
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
