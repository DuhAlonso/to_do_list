import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicPreferencies extends StatefulWidget {
  const BasicPreferencies({Key? key}) : super(key: key);

  @override
  _BasicPreferenciesState createState() => _BasicPreferenciesState();
}

class _BasicPreferenciesState extends State<BasicPreferencies> {
  final TextEditingController _textController = TextEditingController();
  String _msg = 'Nada Salvo!';

  _saved() async {
    String txtDigitado = _textController.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('text', txtDigitado);
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _msg = prefs.getString('text') ?? 'Sem valor';
    });
  }

  _delete() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manipulando dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              _msg,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            TextField(
              controller: _textController,
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                label: Text('Digite algo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonOptions(_saved, 'Salvar'),
                  buttonOptions(_read, 'Ler'),
                  buttonOptions(_delete, 'Excluir')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonOptions(Function onPress, String label) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        fixedSize: const Size(100, 40),
      ),
      onPressed: () {
        onPress();
      },
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
