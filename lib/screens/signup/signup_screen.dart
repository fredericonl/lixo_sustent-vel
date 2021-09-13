import 'package:flutter/material.dart';
import 'package:lixo_sustentavel/helpers/validator.dart';
import 'package:lixo_sustentavel/models/user.dart';
import 'package:lixo_sustentavel/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Criar Conta"),
        actions: <Widget>[],
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true, //ocupar o menor espaço possível na tela
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Nome Completo:"),
                      validator: (name) {
                        if (name.isEmpty)
                          return "Campo Obrigatório!";
                        //trim retira os espaços do início e fim do texto e splite procura a string digitada e conta.
                        else if (name.trim().split(" ").length <= 1)
                          return "Preencha o Nome Completo";
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email.isEmpty) {
                          return "Campo Obrigatório";
                        } else if (!emailValid(email)) {
                          return "e-mail inválido";
                        }
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return "Campo Obrigatório";
                        } else if (pass.length < 6) {
                          return "Senha muito curta";
                        }
                        return null;
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Repita a Senha"),
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return "Campo Obrigatório";
                        } else if (pass.length < 6) {
                          return "Senha muito curta";
                        }
                        return null;
                      },
                      onSaved: (pass) => user.confirmPassword = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        height: 44,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          disabledColor: //modifica a cor (para náo ficar cinza) do botao quando estiver validando
                              Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          onPressed: () {
                            if (formkey.currentState.validate()) {
                              formkey.currentState.save();
                            }

                            if (user.password != user.confirmPassword) {
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Senhas não Coincidem!",
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<UserManager>().signUP(
                                  user: user,
                                  onSuccess: () {
                                    Navigator.of(context).pop();
                                  },
                                  onFail: (e) {
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Falha ao Cadastrar: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                );
                          },
                          child: Text(
                            "Criar Conta",
                            style: TextStyle(fontSize: 18),
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
