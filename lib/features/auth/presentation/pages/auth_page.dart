import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/widgets/app_title.dart';
import 'package:vida_a_dois/core/widgets/app_slogan.dart';
import 'package:vida_a_dois/core/widgets/divider_with_label.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';

/// TODO: implement form and form validator so that all field
/// validations are unified
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool createAccount = false;
  bool obscurePassword = true;

  late final AuthBloc authBloc;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  void unfocusFields() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    confirmPasswordFocusNode.unfocus();
  }

  String? emailValidator(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        value.contains(RegExp(r"^\w+.*\@{1}.+\.+.+$")) &&
        !value.contains(' ')) {
      return null;
    }
    return L10n.of(context).invalidEmailAddress;
  }

  String? passwordValidator(String? value) {
    final l10n = L10n.of(context);

    if (value == null || value.isEmpty) return l10n.passwordCannotBeBlank;

    if (!createAccount) return null;

    if (passwordCtrl.text == confirmPasswordCtrl.text) return null;

    return l10n.passwordsDontMatch;
  }

  void forgotPassword() {
    unfocusFields();
    //TODO: implement forgot password
  }

  void createUser() {
    unfocusFields();
    if ((emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) &&
        passwordCtrl.text != confirmPasswordCtrl.text) {
      return;
    }
    authBloc.add(
      CreateUserWithEmailAndPassword(emailCtrl.text, passwordCtrl.text),
    );
  }

  void signIn() {
    unfocusFields();
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      return;
    }

    authBloc.add(
      SignInWithEmailAndPassword(emailCtrl.text, passwordCtrl.text),
    );
  }

  void signInWithGoogle() async {
    unfocusFields();
    authBloc.add(SignInWithGoogle());
  }

  void toggleLoginSignup() {
    setState(() => createAccount = !createAccount);
  }

  void toggleObscurePassword() {
    setState(() => obscurePassword = !obscurePassword);
  }

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final deviceHeight = MediaQuery.of(context).size.height;
    bool isShittyDevice = deviceHeight < 1000;

    final height = deviceHeight * (isShittyDevice ? 1 : 0.5);
    final width =
        MediaQuery.of(context).size.width * (isShittyDevice ? 0.9 : 0.7);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: !isShittyDevice,
        body: Center(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // app logo + slogan
                const Center(child: AppTitle()),
                const AppSlogan(),
                // email
                TextFormField(
                  autofocus: false,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailCtrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: l10n.email,
                    border: const OutlineInputBorder(),
                  ),
                  validator: emailValidator,
                ),
                // password
                TextFormField(
                    autofocus: false,
                    focusNode: passwordFocusNode,
                    controller: passwordCtrl,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: obscurePassword,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: l10n.password,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: toggleObscurePassword,
                        icon: obscurePassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                    validator: passwordValidator),
                // confirm password | forgot password?
                createAccount
                    ? TextFormField(
                        autofocus: false,
                        focusNode: confirmPasswordFocusNode,
                        controller: confirmPasswordCtrl,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: obscurePassword,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: l10n.confirmPassword,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: toggleObscurePassword,
                            icon: obscurePassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        validator: passwordValidator,
                      )
                    : Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: forgotPassword,
                          child: Text(l10n.forgotPassword),
                        ),
                      ),
                FilledButton(
                  onPressed: createAccount ? createUser : signIn,
                  child: Text(
                    createAccount ? l10n.createAccount : l10n.signIn,
                  ),
                ),
                // or
                Padding(
                  padding: EdgeInsets.all(isShittyDevice ? 0 : 20),
                  child: DividerWithLabel(label: l10n.or.toUpperCase()),
                ),
                // sign in with google
                ElevatedButton.icon(
                  onPressed: signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  label: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        createAccount
                            ? l10n.signUpWithGoogle
                            : l10n.signInWithGoogle,
                      ),
                      SizedBox(width: isShittyDevice ? 0 : 20),
                    ],
                  ),
                  iconAlignment: IconAlignment.start,
                  icon: Image.asset(
                    'assets/signin-assets/android_light_rd_na@1x.png',
                    scale: 1.5,
                  ),
                ),
                // already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(createAccount
                        ? l10n.alreadyHaveAnAccount
                        : l10n.notAMember),
                    TextButton(
                      onPressed: toggleLoginSignup,
                      child: Text(
                        createAccount ? l10n.signInNow : l10n.signUpNow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
