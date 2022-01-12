const String getNewPoolsByCountryQuery = '''
      query MyQuery(\$countryCode: String = "us", \$userId: String = "", \$offset: Int = 0) {
        pools(limit: 4, offset: \$offset, order_by: {createdAt: asc}, where: {countryCode: {_eq: \$countryCode}, _and: {_or: [{votes: {userId: {_neq: \$userId}}}, {totalVotes: {_eq: 0}}]}}) {
          id
          title
          userId
          choices(order_by: {id: asc}) {
            title
            poolId
            id
            nbrVotes
          }
          user {
            displayName
            profilePicUrl
          }
          hashtags {
            hashtag {
              id
              title
            }
          }
        }
      }
''';

const String getNewPoolsByLanguageQuery = '''
      query MyQuery(\$languageCode: String = "en", \$userId: String = "") {
        pools(limit: 4, offset: 0, order_by: {createdAt: asc}, where: {languageCode: {_eq: \$languageCode}, _and: {_or: [{votes: {userId: {_neq: \$userId}}}, {totalVotes: {_eq: 0}}]}}) {
          id
          title
          userId
          choices(order_by: {id: asc}) {
            title
            poolId
            id
            nbrVotes
          }
          user {
            displayName
            profilePicUrl
          }
          hashtags {
            hashtag {
              id
              title
            }
          }
        }
      }
''';

