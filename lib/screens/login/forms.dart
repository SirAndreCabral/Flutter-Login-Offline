import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Forms extends StatefulWidget {
  const Forms({super.key});

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  final TextEditingController _controller = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '##.####-##',
    filter: {"#": RegExp(r'[0-9]')}
  );

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "R.A",
              ),
            )
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "senha",
                hintText: "Digite sua senha",
                isDense: true,
                border: const OutlineInputBorder(),
                suffix: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            )
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextButton(
              onPressed: () {
                print("RA digitado: ${maskFormatter.getMaskedText()}");
                print("Senha digitada: ${_controller.text}");
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.indigo),
              ),
              child: const Text("Entrar"),
            ),
          )
        ],
      ),
    );
  }
}
