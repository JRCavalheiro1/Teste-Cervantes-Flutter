import 'package:cadastro_flutter/db_helper/db_helper.dart';
import 'package:cadastro_flutter/pages/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_flutter/pages/utils/custom_widgets/custom_text_form_field.dart';
import 'package:cadastro_flutter/pages/utils/custom_widgets/custom_button.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final dataBaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _registrations = [];
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _loadRegistrations();
  }

  void _loadRegistrations() async {
    final data = await DatabaseHelper().queryAllCadastros();
    setState(() {
      _registrations = data;
    });
  }

  // método que cadastra um novo registro
  void _register() async {
    String text = _textController.text;
    int? number = _isValidNumber(_numberController.text);

    if (text.isNotEmpty && number != null) {
      try {
        await dataBaseHelper.insertCadastro({
          'texto': text,
          'numero': number,
        });

        _textController.clear();
        _numberController.clear();
        _loadRegistrations();
        print("Registro realizado com sucesso!");
      } catch (e) {
        if (e is DatabaseException && e.isUniqueConstraintError()) {
          print('Este número já está cadastrado');
        } else {
          print('Erro ao registrar ${e.toString()}');
        }
      }
    } else {
      print("Preencha os campos corretamente!");
    }
  }

  void _edit() async {
    if (_selectedId == null) {
      print('Nenhum registro selecionado para edição!');
      return;
    }
    String text = _textController.text;
    int? number = _isValidNumber(_numberController.text);

    if (text.isNotEmpty && number != null) {
      await dataBaseHelper.updateCadastro(_selectedId!, {
        'texto': text,
        'numero': number,
      });

      _textController.clear();
      _numberController.clear();
      _selectedId = null;
      _loadRegistrations();

      print("Dados atualizados com sucesso!");
    } else {
      print("Preencha os campos corretamente!");
    }
  }

  void _delete() async {
    if (_selectedId == null) {
      print("Nenhum registro selecionado para exclusão!");
      return;
    }
    await dataBaseHelper.deleteCadastro(_selectedId!);
    _textController.clear();
    _numberController.clear();
    _selectedId = null;
    _loadRegistrations();

    print("Registro deletado com sucesso!");
  }

  //verifica se o campo passado é um número válido
  int? _isValidNumber(String numberIput) {
    if (numberIput.isEmpty) {
      return null;
    }
    int? validNumber = int.tryParse(numberIput);
    if (validNumber == null || validNumber < 0) {
      return null;
    }
    return validNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.dark,
        appBar: AppBar(
            title: Center(child: Text('Cadastro App')),
            titleTextStyle: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            backgroundColor: AppTheme.dark),
        body: Center(
            child: Column(
          children: [
            SizedBox(height: 40),
            SizedBox(
              width: 400.0,
              child: CustomTextFormField(
                controllerVariable: _textController,
                labelText: "Texto",
                hintText: "Digite um texto",
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 400.0,
              child: CustomTextFormField(
                controllerVariable: _numberController,
                labelText: "Número",
                hintText: "Digite um número",
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  onPressed: _register,
                  text: "Cadastrar",
                  type: ButtonType.primary,
                ),
                SizedBox(width: 20),
                CustomButton(
                  onPressed: _edit,
                  text: "Editar",
                  type: ButtonType.primary,
                ),
                SizedBox(width: 20),
                CustomButton(
                  onPressed: _delete,
                  text: "Deletar",
                  type: ButtonType.delete,
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      'Id',
                      style:
                          TextStyle(color: Color(0xFFFFFFFF), fontSize: 18.0),
                    )),
                    DataColumn(
                        label: Text(
                      'Texto',
                      style:
                          TextStyle(color: Color(0xFFFFFFFF), fontSize: 18.0),
                    )),
                    DataColumn(
                        label: Text(
                      'Número',
                      style:
                          TextStyle(color: Color(0xFFFFFFFF), fontSize: 18.0),
                    )),
                  ],
                  rows: _registrations.map((register) {
                    return DataRow(
                      selected: _selectedId == register['id'],
                      onSelectChanged: (selected) {
                        if (selected == true) {
                          setState(() {
                            _selectedId = register['id'];
                            _textController.text = register['texto'];
                            _numberController.text =
                                register['numero'].toString();
                          });
                        }
                      },
                      cells: [
                        DataCell(Text(
                          register['id'].toString(),
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        )),
                        DataCell(Text(
                          register['texto'],
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        )),
                        DataCell(Text(
                          register['numero'].toString(),
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        )));
  }
}
