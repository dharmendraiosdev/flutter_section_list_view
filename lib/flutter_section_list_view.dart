library flutter_section_list_view;

import 'package:flutter/widgets.dart';

typedef int NumberOfRowsCallBack(int section);
typedef Widget SectionWidgetCallBack(int section);
typedef Widget RowsWidgetCallBack(int section, int row);

class FlutterSectionListView extends StatefulWidget {
  FlutterSectionListView({
    this.numberOfSection = 0,
    @required this.numberOfRowsInSection,
    this.sectionWidget,
    @required this.rowWidget,
  }) : assert(!(numberOfRowsInSection == null || rowWidget == null),
            'numberOfRowsInSection and rowWidget are mandatory');

  /// Defines the total number of sections
  final int numberOfSection;

  /// Mandatory callback method to get the rows count in each section
  final NumberOfRowsCallBack numberOfRowsInSection;

  /// Callback method to get the section widget
  final SectionWidgetCallBack sectionWidget;

  /// Mandatory callback method to get the row widget
  final RowsWidgetCallBack rowWidget;

  @override
  _FlutterSectionListViewState createState() => _FlutterSectionListViewState();
}

class _FlutterSectionListViewState extends State<FlutterSectionListView> {
  /// List of total number of rows and section in each group
  var itemList = new List<int>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItemCount(),
      itemBuilder: (BuildContext context, int index) {
        return buildItemWidget(index);
      },
      key: widget.key,
    );
  }

  /// Get the total count of items in list(including both row and sections)
  int listItemCount() {
    int rowCount = 0;
    for (int i = 0; i < widget.numberOfSection; i++) {
      /// Get the number of rows in each section using callback
      int rows = widget.numberOfRowsInSection(i);

      /// Here 1 is added for each section in one group
      rowCount += rows + 1;
      itemList.insert(i, rowCount);
    }
    return rowCount;
  }

  /// Get the widget for each item in list
  Widget buildItemWidget(int index) {
    IndexPath indexPath = sectionModel(index);

    /// If the row number is -1 of any indexPath it will represent a section else row
    if (indexPath.row < 0) {
      return widget.sectionWidget != null
          ? widget.sectionWidget(indexPath.section)
          : SizedBox(
              height: 0,
            );
    } else {
      return widget.rowWidget(indexPath.section, indexPath.row);
    }
  }

  /// Calculate/Map the indexPath for an item Index
  IndexPath sectionModel(int index) {
    int row = 0;
    int section = 0;
    for (int i = 0; i < widget.numberOfSection; i++) {
      int item = itemList[i];
      if (index < item) {
        row = index - (i > 0 ? itemList[i - 1] : 0) - 1;
        section = i;
        break;
      }
    }
    return IndexPath(section: section, row: row);
  }
}

/// Helper class for indexPath of each item in list
class IndexPath {
  IndexPath({this.section, this.row});

  int section = 0;
  int row = 0;
}
