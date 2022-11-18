import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Liberdade'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  int index = 0;
  bool termsAccepted = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> list1 = <String>[
    'Selecione uma opção',
    'Solteiro',
    'Casado',
    'Outros'
  ];

  List<String> list2 = <String>[
    'Selecione uma opção',
    'Feminino',
    'Masculino',
    'Outros'
  ];

  late String dropdownValue1;
  late String dropdownValue2;

  void _sendForm(String nome, String dataNascimento, String estadoCivil,
      String genero) async {
    await FirebaseFirestore.instance.collection("registros").add({
      "Nome": nome,
      "Data de Nascimento": dataNascimento,
      "Estado Civil": estadoCivil,
      "Gênero": genero
    });
  }

  @override
  void initState() {
    dropdownValue1 = list1.first;
    dropdownValue2 = list2.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: index == 0
            ? SingleChildScrollView(
                child: Center(
                child: Form(
                    key: formKey,
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                            TextFormField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                hintText: "Nome",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "O nome não deve ficar em branco";
                                }
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.075),
                            TextFormField(
                              controller: _dataNascimentoController,
                              inputFormatters: [
                                MaskTextInputFormatter(mask: "##/##/####")
                              ],
                              decoration: const InputDecoration(
                                hintText: "Data de Nascimento",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "A data de nascimento deve ser informada";
                                }
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.075),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: DropdownButton<String>(
                                  value: dropdownValue1,
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left: 140),
                                      child: Icon(Icons.arrow_downward)),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue1 = value!;
                                    });
                                  },
                                  items: list1.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.075),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: DropdownButton<String>(
                                  value: dropdownValue2,
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left: 140),
                                      child: Icon(Icons.arrow_downward)),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue2 = value!;
                                    });
                                  },
                                  items: list2.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          termsAccepted = !termsAccepted;
                                        });
                                      },
                                      child: Icon(
                                        termsAccepted == true
                                            ? Icons.circle
                                            : Icons.circle_outlined,
                                        color: termsAccepted == true
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.2),
                                                    child:
                                                        const SingleChildScrollView(
                                                            child: Text(
                                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\n\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.\n\nThe point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).\n\nConcordando com este termo de uso, declaro que todas as informações transmitidas podem ser comercializadas para qualquer finalidade, sem imposições, restrições ou qualquer impedimento legal. Por fim, todos os dados aqui presentes se fazem de inteira propriedade do autor.",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          letterSpacing: 2,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          color: Colors.black),
                                                    )),
                                                  ));
                                        },
                                        child: RichText(
                                            text: const TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  " Declaro que li e concordo com os ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black)),
                                          TextSpan(
                                              text: "termos de uso",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 12,
                                                  color: Colors.black))
                                        ])))
                                  ],
                                )),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                            TextButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate() &&
                                      termsAccepted) {
                                    _sendForm(
                                        _nomeController.text,
                                        _dataNascimentoController.text,
                                        dropdownValue1,
                                        dropdownValue2);

                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        backgroundColor:
                                            Colors.deepOrangeAccent,
                                        title: 'Formulário enviado',
                                        text: 'Obrigado!',
                                        autoCloseDuration:
                                            const Duration(seconds: 2));

                                    setState(() {
                                      index = 1;
                                    });
                                  } else if (!termsAccepted) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1,
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.4),
                                              child: const Text(
                                                "Você deve concordar com os termos de uso para prosseguir",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 2,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: Colors.red),
                                              ),
                                            ));
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 200,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Text(
                                      "Enviar",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ))),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.2),
                            SizedBox(
                                child: Column(
                              children: [
                                const Text("Powered by",
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic)),
                                Image.asset('assets/rango-laranja.png',
                                    height: 80, width: 200),
                              ],
                            ))
                          ],
                        ))),
              ))
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 300),
                    const Text("Link da apresentação ⬇️",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 28)),
                    const SizedBox(height: 40),
                    TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse(
                              "https://www.canva.com/design/DAFSIM9YR78/DACiB4JwX2-7bm02pdJxfA/view?utm_content=DAFSIM9YR78&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton"));
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Text(
                              "Clique para abrir",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )))
                  ],
                ),
              ));
  }
}
