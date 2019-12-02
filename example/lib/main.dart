import 'package:flutter/material.dart';
import 'package:flutter_section_list_view/flutter_section_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Section List View'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FlutterSectionListView(
          numberOfSection: 6,
          numberOfRowsInSection: (section) {
            return section * 3 + 1;
          },
          sectionWidget: (section) {
            return Container(child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Section $section'),
            ), color: Colors.grey,);
          },
          rowWidget: (section, row) {
            return Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Row $section - $row'),
              ),
            );
          },
        )
    );
  }
}
