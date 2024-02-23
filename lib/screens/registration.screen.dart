import 'package:expense_app/models/register_user.model.dart';
import 'package:expense_app/screens/dashboard.screen.dart';
import 'package:expense_app/services/login/login.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController, _userNameController, _passwordController;

  RegistrationScreen({super.key}) {
    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150, width: 150, child: SvgPicture.asset('assets/images/login_background.svg')),
                const SizedBox(height: 10),
                const Text('Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter name';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userNameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter name';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          }

                          if (_passwordController.text.isNotEmpty && _passwordController.text != value) {
                            return 'Passwords don\'t match';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 60.0),
                          ),
                        ),
                        onPressed: () => _validateAndRegister(context),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var loginService = LoginService();
      if (await loginService.isUsernameExists(_userNameController.text)) {
        _showAlert(context, 'Registration failed', 'User already exists');
        return;
      }

      var registerUser = RegisterUser(
        name: _nameController.text,
        userName: _userNameController.text,
        password: _passwordController.text,
      );

      if (await loginService.registerUser(registerUser)) {
        var preference = await SharedPreferences.getInstance();
        preference.setBool('isLogin', true);
        preference.setString('username', registerUser.userName!);
        preference.setString('password', registerUser.password!);

        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
        }
      } else {
        _showAlert(context, 'Registration failed', 'Something went wrong');
      }
    }
  }

  void _showAlert(BuildContext context, String tile, String message) {
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Login Failure'),
              content: const SizedBox(
                width: 200,
                height: 50,
                child: Text('Invalid user credentials'),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            );
          });
    }
  }
}
