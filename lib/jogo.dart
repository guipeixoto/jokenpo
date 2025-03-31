import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Jogo extends StatefulWidget {
  const Jogo({super.key});

  @override
  State<Jogo> createState() => _JogoState();
}

// ignore: constant_identifier_names
enum RESULTADO { USUARIO, MAQUINA, EMPATE }

class _JogoState extends State<Jogo> {
  var _imagemApp = AssetImage('images/padrao.png');
  var _resultadoFinalText = "Boa sorte!!!";
  // ignore: prefer_typing_uninitialized_variables
  var _resultadoFinal;
  final _constadores = {"usuario": 0, "maquina": 0, "empate": 0};
  late ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _opcaoSelecionada(String escolhaUsuario) {
    var opcoes = ["pedra", "papel", "tesoura"];
    var numero = Random().nextInt(3);
    var escolhaApp = opcoes[numero];

    switch (escolhaApp) {
      case "pedra":
        setState(() {
          _imagemApp = AssetImage('images/pedra.png');
        });
        break;
      case "papel":
        setState(() {
          _imagemApp = AssetImage('images/papel.png');
        });
        break;
      case "tesoura":
        setState(() {
          _imagemApp = AssetImage('images/tesoura.png');
        });
        break;
    }

    if ((escolhaUsuario == "pedra" && escolhaApp == "tesoura") ||
        (escolhaUsuario == "tesoura" && escolhaApp == "papel") ||
        (escolhaUsuario == "papel" && escolhaApp == "pedra")) {
      setState(() {
        _resultadoFinal = RESULTADO.USUARIO;
        _constadores['usuario'] = _constadores['usuario']! + 1;
        _resultadoFinalText = "Parabéns!!! Você ganhou :)";
      });
    } else if ((escolhaApp == "pedra" && escolhaUsuario == "tesoura") ||
        (escolhaApp == "tesoura" && escolhaUsuario == "papel") ||
        (escolhaApp == "papel" && escolhaUsuario == "pedra")) {
      setState(() {
        _resultadoFinal = RESULTADO.MAQUINA;
        _constadores['maquina'] = _constadores['maquina']! + 1;
        _resultadoFinalText = "Puxa!!! Você perdeu :(";
      });
    } else {
      setState(() {
        _resultadoFinal = RESULTADO.EMPATE;
        _constadores['empate'] = _constadores['empate']! + 1;
        _resultadoFinalText = "Empate!!! Tente novamente :/";
      });
    }

    if (_constadores['usuario'] == 3) {
      _confettiController.play();
      _constadores['usuario'] = 0;
      _constadores['maquina'] = 0;
      _constadores['empate'] = 0;

      _resultadoFinalText = "VOCÊ GANHOU A RODADA!!!";
    } else if (_constadores['maquina'] == 3) {
      _constadores['usuario'] = 0;
      _constadores['maquina'] = 0;
      _constadores['empate'] = 0;

      _resultadoFinalText = "QUE PENA, VOCÊ PERDEU PARA MÁQUINA, TENDE DE NOVO!!!";
    }
  }

  Color _corText() {
    return switch (_resultadoFinal) {
      RESULTADO.USUARIO => Colors.blue,

      RESULTADO.MAQUINA => Colors.red,

      RESULTADO.EMPATE => Colors.amber,

      _ => Colors.black,
    };
  }

  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, foregroundColor: Colors.white, title: const Text('JokenPO')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 50,
                  particleDrag: 0.05,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                  createParticlePath: drawStar,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              'Escolha do App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Image(image: _imagemApp),
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              "Escolha uma opção",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () => _opcaoSelecionada("pedra"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('images/pedra.png'), height: 100),
                    Text("PEDRA", textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _opcaoSelecionada("papel"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('images/papel.png'), height: 100),
                    Text("PAPEL", textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _opcaoSelecionada("tesoura"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('images/tesoura.png'), height: 100),
                    Text("TESOURA", textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              _resultadoFinalText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _corText()),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, bottom: 16),
            child: Text(
              "PLACAR",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(137, 80, 80, 80), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("MÁQUINA", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.red)),
                    Text(
                      _constadores['maquina']!.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.red),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("EMPATE", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.amber)),
                    Text(
                      _constadores['empate']!.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.amber),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("USUÁRIO", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.blue)),
                    Text(
                      _constadores['usuario']!.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
