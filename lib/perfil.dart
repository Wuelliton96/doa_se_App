import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 30,
          left: 30,
          right: 30,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              child: Image.asset("assets/doa-se.png"),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  stops: [0.3 , 1],
                  colors: [
                    Color.fromARGB(255, 134, 101, 101),
                    Color.fromARGB(255, 134, 101, 101),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15)
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: SizedBox(
                          child:Image.asset("assets/google.png"),
                          height: 28,
                          width: 28,
                        ),
                      ),
                      const Text(
                        "Cadastrar com Google",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => [],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  stops: [0.3 , 1],
                  colors: [
                    Color.fromRGBO(249, 43, 127, 1),
                    Color.fromRGBO(249, 43, 127, 1),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                )
              ),
              child: SizedBox.expand(
                child: TextButton(
                  child: const Text(
                    "Entrar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20
                    )
                  ),
                  onPressed: () => [],                    
                  ),
                ),
              ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child:  TextButton(
                child: Text(
                  "Esqueceu a senha",
                  textAlign: TextAlign.right,
                ),
                onPressed: null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
