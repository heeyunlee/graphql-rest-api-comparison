import 'package:graphql/client.dart';

import 'my_home_page.dart';
import 'result.dart';

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
