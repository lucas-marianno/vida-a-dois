import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';

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
  final speed = const Duration(milliseconds: 1000);
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
    final height = MediaQuery.of(context).size.height * 0.5;
    final width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //TODO: replace wih app logo
              const Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(child: Icon(Icons.favorite_outline)),
                  Positioned(top: 5, child: Icon(Icons.favorite)),
                ],
              ),
              const SizedBox(height: 10),
              // slogan
              SizedBox(
                height: 25,
                child: AnimatedTextKit(
                  pause: Duration.zero,
                  repeatForever: true,
                  animatedTexts: [
                    for (String sentence in l10n.appSlogan.split('|'))
                      RotateAnimatedText(sentence, duration: speed),
                  ],
                ),
              ),
              // email
              const SizedBox(height: 10),
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
                      obscureText: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: l10n.confirmPassword,
                        border: const OutlineInputBorder(),
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
              const SizedBox(height: 10),
              FilledButton(
                onPressed: createAccount ? createUser : signIn,
                child: Text(
                  createAccount ? l10n.createAccount : l10n.signIn,
                ),
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
                    const SizedBox(width: 20),
                  ],
                ),
                iconAlignment: IconAlignment.start,
                icon: Image.asset(
                  'assets/signin-assets/android_light_rd_na@1x.png',
                  scale: 1.5,
                ),
              ),
              // already have an account?
              const SizedBox(height: 10),
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
    );
  }
}
