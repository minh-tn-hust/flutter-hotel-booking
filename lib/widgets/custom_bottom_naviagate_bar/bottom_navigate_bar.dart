import 'package:flutter/material.dart';

import 'navigate_button.dart';

class BottomNavigaBar extends StatefulWidget {
  const BottomNavigaBar(
      {Key? key, required this.pageView, required this.index, this.isHost})
      : super(key: key);
  final Function(int index) pageView;
  final int index;
  final bool? isHost;
  @override
  _BottomNavigaBarState createState() => _BottomNavigaBarState();
}

class _BottomNavigaBarState extends State<BottomNavigaBar> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void onTapBarButton(int index) {
    widget.pageView(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.index;
    return Container(
      padding: EdgeInsets.only(top: 14, left: 19, bottom: 14, right: 19),
      decoration: BoxDecoration(
        color: Colors.grey[350],
      ),
      height: 70,
      child: (widget.isHost == null)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                NavigateButton(
                  onTap: () {
                    onTapBarButton(0);
                  },
                  selected: _selectedIndex == 0 ? true : false,
                  icon: Icons.home,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                NavigateButton(
                  onTap: () {
                    onTapBarButton(1);
                  },
                  selected: _selectedIndex == 1 ? true : false,
                  icon: Icons.search,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                NavigateButton(
                  onTap: () {
                    onTapBarButton(2);
                  },
                  selected: _selectedIndex == 2 ? true : false,
                  icon: Icons.history,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                NavigateButton(
                  onTap: () {
                    onTapBarButton(3);
                  },
                  selected: _selectedIndex == 3 ? true : false,
                  icon: Icons.dashboard,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                NavigateButton(
                  onTap: () {
                    onTapBarButton(0);
                  },
                  selected: _selectedIndex == 0 ? true : false,
                  icon: Icons.home,
                ),
                Spacer(),
                NavigateButton(
                  onTap: () {
                    onTapBarButton(1);
                  },
                  selected: _selectedIndex == 1 ? true : false,
                  icon: Icons.info,
                ),
                Spacer(),
              ],
            ),
    );
  }
}
