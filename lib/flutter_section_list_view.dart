// ignore_for_file: library_private_types_in_public_api

// library flutter_section_list_view;

import 'package:flutter/material.dart';

typedef NumberOfRowsCallBack = int Function(int section);
typedef NumberOfSectionCallBack = int Function();
typedef SectionWidgetCallBack = Widget Function(int section);
typedef RowsWidgetCallBack = Widget Function(int section, int row);
typedef LoadMoreData = Future<void> Function();
typedef RefreshList = Future<void> Function();

// ignore: must_be_immutable
class FlutterSectionListView extends StatefulWidget {
  FlutterSectionListView({ 
    required this.numberOfRowsInSection,
    required this.rowWidget, this.numberOfSection, this.sectionWidget, this.physics,
    Key? key,
  }) : super(key: key);

  /// Defines the total number of sections
  final NumberOfSectionCallBack? numberOfSection;

  /// Mandatory callback method to get the rows count in each section
  final NumberOfRowsCallBack? numberOfRowsInSection;

  /// Callback method to get the section widget
  final SectionWidgetCallBack? sectionWidget;

  /// Mandatory callback method to get the row widget
  final RowsWidgetCallBack rowWidget;
  
  /// [ScrollPhysics] provided by that behavior will take precedence after[physics]
  final ScrollPhysics? physics;

  /// A callback method used to load more data when listview reached to end.
  LoadMoreData? loadMoreData;

  /// Return false when there are no more pages to return
  bool isMoreAvailable = true;

  /// Handle this callback when need pull to refresh.
  RefreshList? refresh;

  @override
  _FlutterSectionListViewState createState() => _FlutterSectionListViewState();
}

class _FlutterSectionListViewState extends State<FlutterSectionListView> {
  /// List of total number of rows and section in each group
  List<int> itemList = [];
  bool isLoading = false;
  int itemCount = 0;
  int sectionCount = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    sectionCount = widget.numberOfSection!();
    itemCount = listItemCount();
    super.initState();
  }

  Future<void> refreshList() async {
    if (widget.refresh != null) {
      await widget.refresh!().whenComplete(() {
        setState(() {
          sectionCount = widget.numberOfSection!();
          itemCount = listItemCount();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refresh != null) {
      return RefreshIndicator(
          key: _refreshIndicatorKey, onRefresh: refreshList, child: listView());
    } else {
      return listView();
    }
  }

  Widget listView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoading &&
                  widget.isMoreAvailable &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                if (widget.loadMoreData != null) {
                  setState(() {
                    isLoading = true;
                  });
                  final Future<void> loadMoreResult = widget.loadMoreData!();
                  loadMoreResult.whenComplete(() {
                    setState(() {
                      isLoading = false;
                      sectionCount = widget.numberOfSection!();
                      itemCount = listItemCount();
                    });
                  });
                }
              }
              return false;
            },
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return buildItemWidget(index);
              },
              key: widget.key,
              physics: widget.physics,
            ),
          ),
        ),
        Container(
          height: isLoading ? 50.0 : 0,
          color: Colors.transparent,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  /// Get the total count of items in list(including both row and sections)
  int listItemCount() {
    itemList = [];
    int rowCount = 0;

    for (int i = 0; i < sectionCount; i++) {
      /// Get the number of rows in each section using callback
      int rows = widget.numberOfRowsInSection!(i);

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
          ? widget.sectionWidget!(indexPath.section)
          : const SizedBox(
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
    for (int i = 0; i < sectionCount; i++) {
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
  IndexPath({required this.section, required this.row});

  int section = 0;
  int row = 0;
}
