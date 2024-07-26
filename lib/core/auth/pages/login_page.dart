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
  final speed = Duration(milliseconds: 1000);
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

  void createUser() {
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      //TODO: handle mismatched passwords
      return;
    }
    authBloc.add(
      CreateUserWithEmailAndPassword(emailCtrl.text, passwordCtrl.text),
    );
  }

  void signIn() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      //TODO: handle empty texts
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
                  const Icon(Icons.lock),
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
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(
                      hintText: 'password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  createAccount
                      ? TextField(
                          controller: confirmPasswordCtrl,
                          decoration: const InputDecoration(
                            hintText: 'confirm password',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : const SizedBox(),
                  ElevatedButton(
                    onPressed: createAccount ? createUser : signIn,
                    child: Text(createAccount ? 'create account' : 'sign in'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member? '),
                      TextButton(
                        onPressed: toggleLoginSignup,
                        child: const Text('Register now'),
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
