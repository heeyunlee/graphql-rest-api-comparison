import 'dart:convert';

import 'package:graphql/client.dart';

import 'my_home_page.dart';
import 'result.dart';
import 'package:http/http.dart' as http;

final link = HttpLink('https://$baseUrl/graphql');
final client = GraphQLClient(link: link, cache: GraphQLCache());

// TODO: Add your own query here.
const String query = r'''
query Posts($first: Int!) {
    posts(first: $first) {
        nodes {
            id
            title
            date
            excerpt
            featuredImage {
                sourceUrl
            }
            author {
                name
            }
            categories {
                nodes {
                    name
                }
            }
        }
    }
}
''';

final a = gql(
  r'''
  ''',
);

QueryOptions options(int perPage) {
  return QueryOptions(
    document: gql(query),
    variables: <String, dynamic>{
      'first': perPage,
    },
  );
}

Future<Result> postGraphQL(int perPage) async {
  final result = await client.query(options(perPage));

  final response = result.data?['posts']['nodes'] as List<dynamic>;

  return Result(
    body: response,
    statusCode: 200,
    headers: {},
  );
}

Future<Result> restGraphQL(int perPage) async {
  final url = Uri.https(baseUrl, '/graphql');

  final String query = '''
    query {
      posts(first: $perPage) {
        nodes {
          id
          title
        }
      }
    }
  ''';

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'query': query,
    }),
  );

  return Result(
    headers: response.headers,
    statusCode: response.statusCode,
    body: response.body,
    responseBodySizeInBytes: response.bodyBytes.lengthInBytes,
  );
}
