import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/auth/bloc/auth_bloc.dart';

///TODO: implement l10n in [AuthPage]
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
  final crappySentences = [
    'motivational sentence',
    'don\'t worry about whatever',
    'love each other',
    'leave the boring stuff for us',
    'life is beautiful',
    'tasks are boring',
    'yada yada yada',
    'some inspiring bs',
    'help me pay my rent',
    'please buy my app',
  ];

  String? emailValidator(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        value.contains(RegExp(r"^\w+.*\@{1}.+\.+.+$")) &&
        !value.contains(' ')) {
      return null;
    }
    return 'invalid email address';
  }

  void createUser() {
    if ((emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) &&
        passwordCtrl.text != confirmPasswordCtrl.text) {
      return;
    }
    authBloc.add(
      CreateUserWithEmailAndPassword(emailCtrl.text, passwordCtrl.text),
    );
  }

  void signIn() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      return;
    }

    authBloc.add(
      SignInWithEmailAndPassword(emailCtrl.text, passwordCtrl.text),
    );
  }

  void signInWithGoogle() {
    //TODO: implement sign in with google
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
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
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
                        for (String sentence in crappySentences)
                          RotateAnimatedText(sentence, duration: speed),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailCtrl,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder(),
                    ),
                    validator: emailValidator,
                  ),
                  TextFormField(
                    controller: passwordCtrl,
                    obscureText: obscurePassword,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: toggleObscurePassword,
                        icon: obscurePassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                  createAccount
                      ? TextFormField(
                          controller: confirmPasswordCtrl,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'confirm password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (passwordCtrl.text == confirmPasswordCtrl.text) {
                              return null;
                            }
                            return 'passwords don\'t match';
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: createAccount ? createUser : signIn,
                    child: Text(createAccount ? 'Create account' : 'Sign in'),
                  ),

                  FilledButton.icon(
                    onPressed: signInWithGoogle,
                    label: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          createAccount
                              ? 'Sign up with Google'
                              : 'Sign in with Google',
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    iconAlignment: IconAlignment.start,
                    icon: Image.asset(
                      'assets/signin-assets/android_light_rd_na@1x.png',
                      scale: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(createAccount
                          ? 'Already have an account?'
                          : 'Not a member? '),
                      TextButton(
                        onPressed: toggleLoginSignup,
                        child: Text(
                          createAccount ? 'Sign in now' : 'Register now',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
