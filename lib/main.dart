import 'package:flutter/material.dart';
import 'package:gallery/images.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Widget _body;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    _body = Images();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: _drawer,
      body: _body,
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  get _drawer => Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Text(
              "Gallery",
              style: TextStyle(fontSize: 20),
            )),
            ListTile(
              leading: Icon(
                Icons.image,
                color: Colors.deepOrangeAccent,
              ),
              title: Text("Images"),
              onTap: showImages,
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.video_library,
                color: Colors.pinkAccent,
              ),
              title: Text("Video"),
              onTap: showVideos,
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      );

  void showImages() {
    print("show images");
    Navigator.pop(context);
  }

  void showVideos() {
    print("show videos");
  }
}
