import 'package:graphql_rest_comparison/result.dart';
import 'package:http/http.dart' as http;

import 'my_home_page.dart';

Future<Result> getPosts(int perPage) async {
  var url = Uri.https(
    baseUrl,
    '/wp-json/wp/v2/posts',
    {
      'per_page': perPage.toString(),
    },
  );

  final response = await http.get(url);

  return Result(
    headers: response.headers,
    statusCode: response.statusCode,
    body: response.body,
    responseBodySizeInBytes: response.bodyBytes.lengthInBytes,
  );
}
