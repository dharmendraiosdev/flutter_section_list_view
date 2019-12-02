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