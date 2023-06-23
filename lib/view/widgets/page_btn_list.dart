import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageBtnList extends StatelessWidget {
  PageBtnList(
      {super.key,
        required this.maxPage,
        required this.currentPage,
        required this.onPageChangeHandler});
  int maxPage;
  int currentPage;
  Function(int) onPageChangeHandler;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: maxPage,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              onPageChangeHandler(index);
            },
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: currentPage == (index + 1) ? Colors.white : Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }
}