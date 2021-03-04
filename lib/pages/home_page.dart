import 'dart:io';

import 'package:flutter/material.dart';

import 'package:turistando/helpers/camera_helper.dart';
import 'package:turistando/helpers/tflite_helper.dart';
import 'package:turistando/models/tflite_result.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];
  bool controlText = false;
  String urlChateu = 'https://www.google.com/search?sxsrf=ALeKk00AjqVG21b_4hqJ_R0qtSIA9tn0IA:1605635307343&q=chateau+d%27eau+cachoeira+do+sul&sa=X&ved=2ahUKEwiX6IfRkYrtAhXdHrkGHTYrBKAQ7xYoAHoECBAQNQ&biw=1517&bih=666';
  String urlColiseu = 'https://www.google.com/search?sxsrf=ALeKk01bxbGbyYRUL5zMVO-6cBqadsTtMA%3A1605635987997&ei=kw-0X9q_PNa85OUPyryGQA&q=coliseu+roma&oq=Coliseu+roma&gs_lcp=CgZwc3ktYWIQAxgAMgUIABCxAzIFCAAQsQMyAggAMgIIADICCAAyAggAMgIIADICCAAyAggAMgIIADoECAAQRzoECAAQQzoGCAAQChBDOgUIIRCgAToICAAQFhAKEB46BggAEBYQHjoECAAQClDhEljIMGCoN2gGcAJ4AIAB-QGIAbQMkgEGMC4xMC4xmAEAoAEBqgEHZ3dzLXdpesgBCMABAQ&sclient=psy-ab';
  
  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
  }

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: Text('Turistando'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: _pickImage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildResult(),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _image == null
                ? Text('Sem imagem')
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    final image = await CameraHelper.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 30.0),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return Center(
        child: Text('Sem resultados'),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          if (_outputs[index].label == '1 Chateau') {
            if ((_outputs[index].confidence * 100.0) > 90) {
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.turned_in),
                      Text(
                        "Chateau d'eau",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                         if (await canLaunch(urlChateu)) {
                            await launch(urlChateu);
                          }
                        },
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      Text('Cachoeira do Sul - BR/RS',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 25),
                    child: Text(
                        'Sobre: é o principal símbolo de Cachoeira do Sul, a capital nacional do arroz, no Rio Grande do Sul. O projeto arquitetônico, de 1925, foi elaborado pelo engenheiro Walter Jobim e o cálculo estrutural, pelo engenheiro Antônio de Siqueira.'),
                  ),
                ],
              );
            }
          } else if (_outputs[index].label == '0 Coliseu') {
            if ((_outputs[index].confidence * 100.0) > 90) {
              print(_outputs[0].label);
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.turned_in),
                      Text(
                        "Coliseu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Spacer(),
                       IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                         if (await canLaunch(urlColiseu)) {
                            await launch(urlColiseu);
                          }
                        },
                      )

                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      Text('Roma - IT',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                     
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 25),
                    child: Text(
                        'Sobre: Coliseu (em italiano: Colosseo), também conhecido como Anfiteatro Flaviano (em latim: Amphitheatrum Flavium; em italiano: Anfiteatro Flavio), é um anfiteatro oval localizado no centro da cidade de Roma, capital da Itália. Construído com tijolos revestidos de argamassa e areia, e originalmente cobertos com travertino[1] é o maior anfiteatro já construído e está situado a leste do Fórum Romano.'),
                  ),
                ],
              );
            }
          } else {
            return Text('Tente outra foto!');
          }
        },
      ),
    );
  }
}
