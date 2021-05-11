import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:injector/injector.dart';
import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/login/registration/registration_view_model.dart';
import 'package:jetwallet/screens/login/widgets/sign_in_button.dart';
import 'package:jetwallet/screens/login/widgets/styles.dart';
import 'package:jetwallet/state/config/config_storage.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _client = Injector.appInstance.get<SpotWalletClient>();
  final _configStorage = Injector.appInstance.get<ConfigStorage>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegistrationViewModel>(
      converter: (store) => RegistrationViewModel.fromStore(store),
      onDispose: (store) {
        _emailController.dispose();
        _passwordController.dispose();
        _repeatPasswordController.dispose();
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up'),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: backgroundImage,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromRGBO(162, 146, 199, 0.8),
                    Color.fromRGBO(51, 51, 63, 0.9),
                  ],
                  stops: [0.2, 1.0],
                  begin: FractionalOffset(0, 0),
                  end: FractionalOffset(0, 1),
                ),
              ),
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                        contentPadding: EdgeInsets.only(
                          top: 30,
                          right: 30,
                          bottom: 30,
                          left: 5,
                        ),
                      ),
                      onChanged: (email) => vm.setEmail(email),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: vm.isPasswordVisible,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        suffix: IconButton(
                          onPressed: () => vm.setIsPasswordVisible(),
                          icon: Icon(
                            vm.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        contentPadding: const EdgeInsets.only(
                            top: 30, right: 30, bottom: 30, left: 5),
                      ),
                      onChanged: (password) => vm.setPassword(password),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: _repeatPasswordController,
                      obscureText: vm.isRepeatPasswordVisible,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        suffix: IconButton(
                          onPressed: () => vm.setIsRepeatPasswordVisible(),
                          icon: Icon(
                            vm.isRepeatPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Repeat Password',
                        hintStyle:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        contentPadding: const EdgeInsets.only(
                            top: 30, right: 30, bottom: 30, left: 5),
                      ),
                      onChanged: (repeatPassword) =>
                          vm.setRepeatPassword(repeatPassword),
                    ),
                  ),
                  if (!vm.isPasswordsMatch)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Passwords don't match",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 64, right: 64),
                    child: InkWell(
                      onTap: vm.isSignUpEnabled
                          ? () => vm.onRegisterPress(
                                _client,
                                _configStorage,
                                _emailController.text,
                                _passwordController.text,
                              )
                          : null,
                      child: SignIn(
                        isEnabled: vm.isSignUpEnabled,
                        activeColor: Theme.of(context).primaryColor,
                        text: 'Sign Up',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
