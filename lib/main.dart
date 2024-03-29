import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
import 'package:device_info/device_info.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io' show Platform;

void main() {
  runApp(MyApp(
    model: CounterModel(),
  ));
}

class MyApp extends StatelessWidget {
  final CounterModel model;
  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CounterModel>(
        model: model,
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),

      home: FirstRoute(title: 'Segna punti'),
    ),
    );
  }
}

class FirstRoute extends StatefulWidget {
  FirstRoute({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  int _rossi = 0;
  int _blu = 0;
  final _match = 15;

  void _segnanoRossi() async{
    setState(() {
        _rossi++;
      if (_rossi == _match) {
        _generateVincitore("ROSSA", _blu);
      }
    });
  }

  void _segnanoBlu() async{
    setState(() {
      _blu++;
      if (_blu == _match) {
        _generateVincitore("BLU", _rossi);
      }
    });
  }

  void _reset() {
    setState(() {
      _rossi=0;
      _blu=0;
    });
  }

  Future _generateVincitore(String squadra, int ptPerdenti) async {

    await showDialog(
        context: context,
        child: new AlertDialog(
            title: Text('Fine partita'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('HA VINTO LA SQUADRA $squadra !'),
                  Text('Con $_match punti contro i $ptPerdenti punti \'altra squadra.'),
                ]
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Evviva!'),
                onPressed: () {Navigator.of(context).pop();},
              )
            ]
       )
    );
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),
          ],
      ),
      body:  Center(
        child: Align(
          alignment: Alignment.center,
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Expanded(
                      child:
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: Colors.blueGrey[50],
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: Text('$_rossi', style: TextStyle(fontSize: 25)),
                                                radius: 31.0,
                                              )
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(CounterModel()._squadraRossa, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                                          ),
                                        ),
                                      ]
                                  )
                              )
                          )
                      ),
                    ),
                    Expanded(
                      child:
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              color: Colors.blueGrey[50],
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                child: Text('$_blu', style: TextStyle(fontSize: 25)),
                                                radius: 31.0,
                                              )
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(CounterModel()._squadraBlu, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                                          ),
                                        ),
                                      ]
                                  )
                              )
                          )
                      ),
                    ),

                  ]
              ),

              Row(
                children: <Widget>[
                  const SizedBox(height:33),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                      RaisedButton(
                        child: const Text('Aggiungi pt', style: TextStyle(fontSize: 20, color: Colors.white)),
                        color: Colors.red,
                        onPressed: _segnanoRossi,
                      ),
                    ),
                  ),
                  const SizedBox(height: 33),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                      RaisedButton(
                        child: const Text('Aggiungi pt', style: TextStyle(fontSize: 20, color: Colors.white)),
                        color: Colors.blue,
                        onPressed: _segnanoBlu,
                      ),
                    ),
                  ),
                ],
              ),

              //CombinedWidget(),
               ShowWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.cached, color: Colors.white,),
        label: Text("Reset", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        onPressed: _reset,
      ),
    );
  }
}


class SecondRoute extends StatefulWidget  {
  @override
  SecondRouteState createState() {
    return new SecondRouteState();
  }
}

class SecondRouteState  extends State<SecondRoute> implements Exception{
  String _nomeUno = CounterModel()._squadraRossa;
  String _nomeDue = CounterModel()._squadraBlu;

  TextEditingController _nomeUnoController = TextEditingController();
  TextEditingController _nomeDueController = TextEditingController();

  void _updateNomeUno(String value) {
    setState(() {_nomeUno = value;
    CounterModel().updateNameBlu(value);});


  }
  void _updateNomeDue(String value) {
    setState(() {_nomeDue = value;
    CounterModel().updateNameRossa(value);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Navigation menu',
          onPressed: () {
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) => FirstRoute()));
    },
          //},
        ),
        title: Text("Impostazioni"),
      ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Versione 0.0.1 - by Emanuele B. & Eugentio G."),
              Text("Nome 1: $_nomeUno - Nome 2: $_nomeDue"),
              RaisedButton(
                onPressed: _debug,
                child: Text('Genera eccezione'),
              ),
            SettingWidget(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: _nomeUnoController,
                    onSubmitted: _updateNomeUno,
                    decoration: InputDecoration(
                    labelText: 'Squadra 1'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nomeDueController,
                  onSubmitted: _updateNomeDue,
                    decoration: InputDecoration(
                    labelText: 'Squadra 2'),
            ),
              ),

            ]
        )
      ),
    );
  }

  final SentryClient sentry = new SentryClient(dsn: "https://1dc1e073142b4acaa9f4bd83508c6834:c9cafdb2f3cc4333b6e654a4e736535b@sentry.io/1480628");

  void _debug() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String message;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        message = 'Running on ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        message = 'Running on ${iosInfo.utsname.machine}';
      } else {
        message = 'Device type not found';
      }
      debugPrint("Ti avevo avvertito - $message");
      throw new Exception("Ti avevo avvertito - $message");
    } catch (error, stackTrace) {
      await sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}

class CounterModel extends Model  {
  String _squadraRossa ="aa";
  String _squadraBlu ="bb";

  String get nomeUno => _squadraRossa;
  String get nomeDue => _squadraBlu;

  void updateNameRossa(String value) {
    // First, increment the counter
    _squadraRossa = value;

    // Then notify all the listeners.
   // notifyListeners();
  }

  void updateNameBlu(String value) {
    // First, increment the counter
    _squadraBlu = value;

    // Then notify all the listeners.
  //  notifyListeners();
  }

  void updateTest() {
    // First, increment the counter
    _squadraBlu = "CIAO";
    _squadraRossa = "CIAO";

    // Then notify all the listeners.
    notifyListeners();
  }
}

class ShowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<CounterModel>(
        model: new CounterModel(),
        child: new Column(children: [
          new ScopedModelDescendant<CounterModel>(
            rebuildOnChange: true,
            builder: (context, child, model) => new Text('${model.nomeUno}'),
          ),
        ])
    );
  }
}

/**class CombinedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
    ScopedModelDescendant<CounterModel>(
        rebuildOnChange: true,
      builder: (context, child, model) => new Text('${model.nomeUno}'),
    );

  }
}*/

class SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModel<CounterModel>(
        model: new CounterModel(),
        child: new Column(children: [
          new ScopedModelDescendant<CounterModel>(
              rebuildOnChange: true,
            builder: (context, child, model){
              return
                new Column(
                    children: <Widget>[
                    RaisedButton(
                    onPressed:() => model.updateTest(),
              child: Text(
              'Imposta nome CIAO',
              )),
                      new Text('${model.nomeUno}')
                      ]
                );

            }
          ),
        ])
    );
  }
}
