import 'package:expense_app/models/UserLogin.model.dart';
import 'package:expense_app/screens/dashboard.screen.dart';
import 'package:expense_app/screens/registration.screen.dart';
import 'package:expense_app/services/login/login.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _userNameController, _passwordController;

  LoginScreen({super.key}) {
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150, width: 150, child: SvgPicture.asset('assets/images/login_background.svg')),
              const SizedBox(height: 10),
              const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userNameController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter username';
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
                    FilledButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 60.0),
                        ),
                      ),
                      onPressed: () => _validateAndLogin(context),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    _navigateToRegistrationScreen(context);
                  },
                  child: const Text('Not a member? Register'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateAndLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var loginService = LoginService();

      var user = UserLogin(
        username: _userNameController.text,
        password: _passwordController.text,
      );

      if (await loginService.isUsernameExists(_userNameController.text)) {
        return;
      }

      if (await loginService.loginUser(user) != null) {
        var preference = await SharedPreferences.getInstance();
        preference.setBool('isLogin', true);
        preference.setString('username', user.username);
        preference.setString('password', user.password);

        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
        }
      }
    }
  }

  void _navigateToRegistrationScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegistrationScreen();
    }));
  }
}
