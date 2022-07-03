# Comparison of GraphQL and REST API using WordPress API and WPGraphQL

1. Clone the repo

`gh repo clone heeyunlee/graphql-rest-api-comparison`

2. Get WordPress website

3. Install [WPGraphQL](https://www.wpgraphql.com/) plugin to your website

4. Change `baseUrl` and `query` variables to your likings

For example, if you want to fetch the `title`, `date`, `excerpt`, and `authorName` of the posts from your website, you could change variables to something like this:
``` dart 
const baseUrl = 'www.yourname.com';

const String query = r'''
query Posts($first: Int!) {
    posts(first: $first) {
        nodes {
            title
            date
            excerpt
            author {
              name
            }
        }
    }
}
''';
```

Use the tools you like (Postman or Insomnia) to find the Schemas for your query


https://user-images.githubusercontent.com/32585133/177017901-d2ef010d-e893-4455-90a7-503b00726d0f.mov

