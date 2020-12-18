import 'package:flutter/material.dart';
import 'package:web_qr_reader/web_qr_reader.dart';
void main() {
  runApp(QrExampleApp());
}

class QrExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Qr Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QrReaderPage(title: 'Web Qr Reader'),
    );
  }
}

class QrReaderPage extends StatefulWidget {
  QrReaderPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _QrReaderPageState createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  final WebQrReaderController controller = WebQrReaderController();

  @override
  void initState() {
    controller.addListener(() {
      print(controller.value.qrContent);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WebQrReader(
              controller: controller,
            ),
            StreamBuilder(
              stream: controller.scannedDataStream,
              builder: (context,AsyncSnapshot<String> snapshot){
                if(snapshot.hasData){
                  return Text('${snapshot.data}');
                }
                return Text('No Qr Value Yet!!');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () { controller.pause();  },
                  child: Text(
                    'Pause'
                  ),
                ),
                MaterialButton(
                  onPressed: () { controller.play();  },
                  child: Text(
                    'Resume'
                  ),
                )
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
