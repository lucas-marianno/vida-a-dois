import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

///TODO: implement l10n in [AuthPage]
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool createAccount = true;

  @override
  Widget build(BuildContext context) {
    const speed = Duration(milliseconds: 1000);
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
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  createAccount
                      ? const TextField(
                          decoration: InputDecoration(
                            hintText: 'confirm password',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : const SizedBox(),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(createAccount ? 'create account' : 'sign in'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member? '),
                      TextButton(
                        onPressed: () {},
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
