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
  late final AuthBloc authBloc;
  bool createAccount = false;
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

  void toggleLoginSignup() {
    setState(() => createAccount = !createAccount);
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
              height: MediaQuery.of(context).size.height / 3,
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
                    obscureText: true,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'password',
                      border: OutlineInputBorder(),
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
                  ElevatedButton(
                    onPressed: createAccount ? createUser : signIn,
                    child: Text(createAccount ? 'create account' : 'sign in'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(createAccount
                          ? 'Already have an account?'
                          : 'Not a member? '),
                      TextButton(
                        onPressed: toggleLoginSignup,
                        child: Text(
                            createAccount ? 'Sign in now' : 'Register now'),
                      ),
                    ],
                  ),
                  const Divider(),
                  FilledButton(
                    onPressed: () {},
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        'assets/signin-assets/android_light_rd_na@1x.png',
                        scale: 1.2,
                      ),
                      title: Text(
                        'Sign in with Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  )
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
