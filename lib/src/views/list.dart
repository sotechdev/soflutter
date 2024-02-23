import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SOListView<TData> extends StatefulWidget {
  SOListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.loadMore,
    this.header,
    this.headerHeight = 50,
  }) : super(key: key);

  final _state = _SOListViewState<TData>();
  final List<TData> items;
  final Future<List<TData>> Function()? loadMore;
  final Widget? Function(BuildContext, TData) itemBuilder;
  final Widget? header;
  final double headerHeight;

  void scrollToTop() {
    _state.scrollToTop();
  }

  void scrollToBottom() {
    _state.scrollToBottom();
  }

  @override
  // ignore: no_logic_in_create_state
  _SOListViewState<TData> createState() => _state;
}

class _SOListViewState<TData> extends State<SOListView<TData>> {
  final logger = Logger();
  final controller = ScrollController();

  List<TData> _items = [];
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    controller.addListener(scrollingEnds);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.header != null)
          SizedBox(
            height: widget.headerHeight,
            child: widget.header,
          ),
        Padding(
          padding: EdgeInsets.only(top: widget.header != null ? 50 : 0),
          child: Scrollbar(
            controller: controller,
            child: ListView.builder(
              controller: controller,
              itemBuilder: (context, index) =>
                  widget.itemBuilder(context, _items[index]),
              itemCount: _items.length,
            ),
          ),
        ),
        if (_isLoadMoreRunning)
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 40),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  void scrollToTop() {
    controller.animateTo(
      controller.position.minScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void scrollToBottom() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loadMore() async {
    if (!_hasNextPage || _isLoadMoreRunning || widget.loadMore == null) return;

    setState(() {
      _isLoadMoreRunning = true;
    });
    try {
      final fetchedData = await widget.loadMore!();
      if (fetchedData.isEmpty) {
        _hasNextPage = false;
        showSnackBar('Nada mais a carregar!');
      } else {
        setState(() {
          _items.addAll(fetchedData);
        });
      }
    } catch (e) {
      logger.e('Erro ao carregar dados: $e');
    }
    setState(() {
      _isLoadMoreRunning = false;
    });
  }

  void scrollingEnds() {
    if (controller.position.extentAfter < 300) {
      loadMore();
    }
  }
}
