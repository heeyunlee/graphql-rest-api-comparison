import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_rest_comparison/graphql.dart';
import 'package:graphql_rest_comparison/result.dart';
import 'package:graphql_rest_comparison/rest_api.dart';
import 'package:path_provider/path_provider.dart';

import 'body_widget.dart';

const rhodamineColor = Color(0xffE10098);
const perPage = 10;

// TODO: Add your own website here.
const baseUrl = 'www.denverpost.com';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Duration _restDuration = Duration.zero;
  Result? _restResponse;
  String _restResponseSize = '0 B';

  Duration _graphQLDuration = Duration.zero;
  Result? _graphQLResponse;
  String _graphQLResponseSize = '0 B';

  Duration _graphQLRestDuration = Duration.zero;
  Result? _graphQLRestResponse;
  String _graphQLRestResponseSize = '0 B';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(setStateOnTabChange);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(setStateOnTabChange)
      ..dispose();
    super.dispose();
  }

  void setStateOnTabChange() {
    if (_tabController.index != _tabController.previousIndex &&
        !_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('REST vs. GraphQL'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('REST'),
            ),
            Tab(
              child: Text(
                'GraphQL',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  color: rhodamineColor,
                ),
              ),
            ),
            Tab(
              child: Text('REST GraphQL'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BodyWidget(
            data: _restResponse?.body,
            duration: _restDuration,
            responseSize: _restResponseSize,
          ),
          BodyWidget(
            data: _graphQLResponse?.body,
            duration: _graphQLDuration,
            responseSize: _graphQLResponseSize,
          ),
          BodyWidget(
            data: _graphQLRestResponse?.body,
            duration: _graphQLRestDuration,
            responseSize: _graphQLRestResponseSize,
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? _buildFABForREST()
          : _tabController.index == 1
              ? _buildFABForGraphQL()
              : _buildFABForGraphQLRest(),
    );
  }

  FloatingActionButton _buildFABForREST() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final start = DateTime.now();
        _restResponse = await getPosts(perPage);

        _restDuration = DateTime.now().difference(start);
        _restResponseSize = await getResponseDataSize(
          bytes: _restResponse?.responseBodySizeInBytes ?? 0,
        );

        setState(() {});
      },
      label: const Text('GET'),
    );
  }

  FloatingActionButton _buildFABForGraphQL() {
    return FloatingActionButton.extended(
      backgroundColor: rhodamineColor,
      onPressed: () async {
        final start = DateTime.now();
        _graphQLResponse = await postGraphQL(perPage);
        _graphQLDuration = DateTime.now().difference(start);
        _graphQLResponseSize = await getResponseDataSize(
          response: _graphQLResponse?.body,
        );

        setState(() {});
      },
      label: const Text('POST'),
    );
  }

  FloatingActionButton _buildFABForGraphQLRest() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.purpleAccent,
      onPressed: () async {
        final start = DateTime.now();
        _graphQLRestResponse = await restGraphQL(perPage);
        _graphQLRestDuration = DateTime.now().difference(start);
        _graphQLRestResponseSize = await getResponseDataSize(
          response: _graphQLRestResponse?.body,
        );

        setState(() {});
      },
      label: const Text('GraphQL Rest'),
    );
  }
}

Future<String> getResponseDataSize({int? bytes, Object? response}) async {
  if (bytes != null) {
    return formatBytes(bytes);
  } else if (response != null) {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/response.text');
    final fileComplete = await file.writeAsString(response.toString());
    final readAsBytes = await fileComplete.readAsBytes();

    return formatBytes(readAsBytes.length);
  } else {
    return '0 B';
  }
}

String formatBytes(int bytes) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}
