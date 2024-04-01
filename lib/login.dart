import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleSignIn() async {
    try {
      await signInWithGoogle();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/states');
    } catch (error) {
      print('Erro ao fazer login com o Google: $error');
    }
  }

  void _handleLogin() {
    String user = _userController.text;
    String password = _passwordController.text;

    if (user == 'test' && password == 'test') {
      // Navegar para a próxima página
      Navigator.pushReplacementNamed(context, '/states');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro de login'),
            content: const Text('Usuário ou senha incorretos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  signInWithGoogle() async {
    // await Firebase.initializeApp();
    print('Login com o Google');
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    print('1');

    GoogleSignInAuthentication? googleAuth =
        await googleSignInAccount?.authentication;
    print('2');

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print('3');

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Login com sucesso, obter o token de acesso
        final AccessToken accessToken = result.accessToken!;
        print('Token de acesso do Facebook: ${accessToken.token}');

        // Aqui você pode prosseguir com a autenticação do usuário
        // por exemplo, enviar o token de acesso para o seu servidor

        // Navegar para a próxima tela após o login
        Navigator.pushReplacementNamed(context, '/next_screen');
      } else {
        // O usuário cancelou o login ou ocorreu um erro
        print('Erro ao fazer login com o Facebook: ${result.message}');
      }
    } catch (e) {
      // Tratar exceções, se houver
      print('Erro ao fazer login com o Facebook: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color.fromARGB(255, 6, 17, 51)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _userController,
                          decoration: InputDecoration(
                            labelText: 'Usuário',
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity,
                                50), // Definindo o tamanho mínimo do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red, primary: Colors.white,
                            minimumSize: const Size(double.infinity,
                                50), // Definindo o tamanho mínimo do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.vpn_key, color: Colors.red),
                              SizedBox(width: 10),
                              Text('Entrar com o Google'),
                            ],
                          ),
                        ),
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
}
