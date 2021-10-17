import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/admin/admin_frame.dart';
import 'package:hotel_booking_app/host/host_frame.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/user_frame.dart';
import 'package:hotel_booking_app/widgets/login_screen/widgets/baned_screen.dart';
import 'package:hotel_booking_app/widgets/login_screen/widgets/forget_password.dart';
import 'package:hotel_booking_app/widgets/login_screen/widgets/login_form.dart';
import 'package:hotel_booking_app/widgets/login_screen/widgets/register_form.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    required this.state,
    this.canBack,
  }) : super(key: key);
  final ApplicationState state;
  final bool? canBack;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.state.loginState) {
      case ApplicationLoginState.admin:
        return AdminFrame();
      case ApplicationLoginState.baned:
        return BanedScreen();
      case ApplicationLoginState.login:
        return LoginForm(
          context: context,
          canBack: widget.canBack,
        );
      case ApplicationLoginState.loggedOut:
      case ApplicationLoginState.user:
        return UserFrame();
      case ApplicationLoginState.register:
        return RegisterForm(
          context: context,
          canBack: widget.canBack,
        );
      case ApplicationLoginState.resetPassword:
        return ResetPasswordForm();
      case ApplicationLoginState.host:
        return HostFrame();
      default:
        return Container();
    }
  }
}
