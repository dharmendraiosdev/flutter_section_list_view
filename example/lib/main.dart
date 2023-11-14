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
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> items = [
    ['Item 1', 'Item 2', 'Item 3'],
    ['Item 4', 'Item 5'],
    ['Item 6', 'Item 7', 'Item 8', 'Item 9'],
    ['Item 10', 'Item 11'],
    ['Item 12', 'Item 13'],
    ['Item 14', 'Item 15', 'Item 16'],
    ['Item 17', 'Item 18']
  ];

  @override
  Widget build(BuildContext context) {
    FlutterSectionListView listView = FlutterSectionListView(
      numberOfSection: () => items.length,
      numberOfRowsInSection: (section) {
        return items[section].length;
      },
      sectionWidget: (section) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Section $section'),
          ),
          color: Colors.grey,
        );
      },
      rowWidget: (section, row) {
        return Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(items[section][row]),
          ),
        );
      },
    );

    listView.loadMoreData = () async {
      await new Future.delayed(new Duration(seconds: 2));
      items.add(['Item 19', 'Item 20']);
      items.add(['Item 21', 'Item 22', 'Item 23']);
      items.removeAt(0);
      items.insert(0, ['Item 0-1', 'Item 1-2']);
      listView.isMoreAvailable = false;
    };

    listView.refresh = () async {
      await new Future.delayed(new Duration(seconds: 3));
      items.removeAt(0);
    };

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: listView);
  }
}
