# flutter_section_list_view

A flutter list view which supports sections like iOS UITableView with no overhead

## Usage

To use this plugin, add flutter_section_list_view as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Getting Started

### Import this class

```dart
import 'flutter_section_list_view/flutter_section_list_view.dart';
```

### Add flutter_section_list_view Widget

After importing this plugin to your project, you can simply use it as a normal widget

```dart

FlutterSectionListView(
        numberOfSection: 4,
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

```

To use Pull-To-Refresh feature, simply provide value to attribute 'refresh', a callback function

```dart
listView.refresh = () async {
      await new Future.delayed(new Duration(seconds: 3));
      print('List Refreshed');
    };
```

For Pagination feature, provide value to attribute 'loadMoreData', a callback function

```dart
listView.loadMoreData = () async {
      await new Future.delayed(new Duration(seconds: 2));
      print('More Data loaded and List refreshed');
      /// set 'isMoreAvailable' attribute to 'false' when there are no more pages to return 
      listView.isMoreAvailable = false;
    };
```