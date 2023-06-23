import 'package:flutter/material.dart';

import '../../controllers/repo/commit.dart';
import '../widgets/commit_list.dart';
import '../widgets/page_btn_list.dart';

class CommitListScreen extends StatefulWidget {
  const CommitListScreen({super.key});

  @override
  State<CommitListScreen> createState() => _CommitListScreenState();
}

class _CommitListScreenState extends State<CommitListScreen> {
  Commit commit = Commit();
  List<dynamic> commitList = [];
  bool isLoading = false;
  String errorTextContainer = "";
  int maxPage = 0;
  int currentPage = 1;

  void fetchAllCommit() {
    setState(() {
      isLoading = true;
    });
    commit.fetchCommits().then((value) {
      setState(() {
        commitList = value;
        maxPage = (commitList.length / 3).ceil();
        isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
        errorTextContainer = "Something went wrong!\n please try again later";
      });
    });
  }

  List<dynamic> getCurrentPageItems() {
    final startIndex = (currentPage - 1) * maxPage;
    final endIndex = startIndex + maxPage;
    if (currentPage == maxPage) {
      return commitList.sublist(startIndex);
    }
    return commitList.sublist(startIndex, endIndex);
  }

  void onPageChangeHandler(int index) {
    setState(() {
      currentPage = index + 1;
    });
  }

  @override
  void initState() {
    fetchAllCommit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Flutter Commit List"),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              child: const Text(
                "master",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: (!isLoading && errorTextContainer.isEmpty)
          ? Column(
        children: [
          Expanded(
            child: CommitList(
              commitList: getCurrentPageItems(),
            ),
          ),
          PageBtnList(
            currentPage: currentPage,
            maxPage: maxPage,
            onPageChangeHandler: onPageChangeHandler,
          ),
        ],
      )
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorTextContainer,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                fetchAllCommit();
              },
              child: const Text(
                "Reload",
              ),
            ),
          ],
        ),
      ),
    );
  }
}