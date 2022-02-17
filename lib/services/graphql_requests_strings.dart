const String getNewPoolsByCountryQuery = '''
      query MyQuery(\$countryCode: String = "us", \$userId: String = "", \$limit: Int = 4, \$offset: Int = 0) {
       pools(limit: \$limit, offset: \$offset, where: {countryCode: {_eq: \$countryCode}, _and: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}], _and:{_or: [{_not: {votes: {}}}, {votes: {userId: {_neq: \$userId}}}]}}}, order_by: {createdAt: desc_nulls_last}) {
          $_poolResponseGraphQL
        }
      }
''';



const String getNewPoolsByLanguageQuery = '''
      query MyQuery(\$languageCode: String = "en", \$userId: String = "", \$limit: Int = 4, \$offset: Int = 0) {
       pools(limit: \$limit, offset: \$offset, where: {languageCode: {_eq: \$languageCode}, _and: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}], _and:{_or: [{_not: {votes: {}}}, {votes: {userId: {_neq: \$userId}}}]}}}, order_by: {createdAt: desc_nulls_last}) {
         $_poolResponseGraphQL
        }
      }
''';

const String getNewPoolsNoFilterQuery = '''
      query MyQuery(\$userId: String = "", \$limit: Int = 4, \$offset: Int = 0) {
        pools(limit: \$limit, offset: \$offset, where: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}], _and: {_or: [{_not: {votes: {}}}, {votes: {userId: {_neq: \$userId}}}]}}, order_by: {createdAt: desc_nulls_last}) {
         $_poolResponseGraphQL
        }
      }
''';

const String getHotPoolsByCountryQuery = '''
      query MyQuery(\$countryCode: String = "us", \$userId: String = "", \$limit: Int = 4, \$offset: Int = 0) {
       pools(limit: \$limit, offset: \$offset, where: {countryCode: {_eq: \$countryCode}, _and: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}], _and:{_or: [{_not: {votes: {}}}, {votes: {userId: {_neq: \$userId}}}]}}}, order_by: {totalVotes: desc}) {
          $_poolResponseGraphQL
        }
      }
''';

const String getClosestPoolsQuery = '''
query MyQuery(\$from: geography = "", \$limit: Int = 6, \$offset: Int = 0) {
  pools(where: {location: {_st_d_within: {distance: 100, from: \$from}}, _and: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}]}}, limit: \$limit, offset: \$offset, order_by: {createdAt: desc_nulls_last}) {
     $_poolResponseGraphQL
  }
}
''';



const String getHotPoolsByLanguageQuery = '''
      query MyQuery(\$languageCode: String = "en", \$userId: String = "", \$limit: Int = 4, \$offset: Int = 0) {
       pools(limit: \$limit, offset: \$offset, where: {languageCode: {_eq: \$languageCode}, _and: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}], _and:{_or: [{_not: {votes: {}}}, {votes: {userId: {_neq: \$userId}}}]}}}, order_by: {totalVotes: desc}) {
         $_poolResponseGraphQL
        }
      }
''';

const String getHotPoolsNoFilterQuery = '''
      query MyQuery(\$userId: String = "", \$limit: Int = 4, \$offset: Int = 0) {
        pools(limit: \$limit, offset: \$offset, where: {_or: [{endDate: {_is_null: true}}, {endDate: {_gt: "now()"}}], _and: {_or: [{_not: {votes: {}}}, {votes: {userId: {_neq: \$userId}}}]}}, order_by: {totalVotes: desc}) {
         $_poolResponseGraphQL
        }
      }
''';

const String getMyPoolsQueryString = '''
query MyQuery(\$userId: String, \$limit: Int = 4, \$offset: Int = 0) {
  pools(limit: \$limit, offset: \$offset, order_by: {createdAt: desc}, where: {userId: {_eq: \$userId}}) {
    id
    title
    userId
    $_choiceResponseGraphQL
    user {
      id
      displayName
      profilePicUrl
    }
    hashtags {
      hashtag {
        id
        title
      }
    }
    votes(where: {userId: {_eq: \$userId}}, , limit: 1) {
      choiceId
      userId
    }
  }
}
''';

const String getMyVotesQueryString = '''
query MyQuery(\$userId: String, \$limit: Int = 4, \$offset: Int = 0) {
  votes(limit: \$limit, offset: \$offset, where: {userId: {_eq: \$userId}}, order_by: {createdAt: asc}) {
    pool {
      id
      title
      userId
      $_choiceResponseGraphQL
      user {
        id
        displayName
        profilePicUrl
      }
      hashtags {
        hashtag {
          id
          title
        }
      }
      votes(where: {userId: {_eq: \$userId}}, limit: 1) {
        choiceId
        userId
      }
    }
  }
}

''';

const String getSearchString = '''
query MyQuery(\$search: String = "", \$userId: String ="", \$limit: Int = 4, \$offset: Int = 0) {
  pools(limit: \$limit, offset: \$offset, where: {_or: [{hashtags: {hashtag: {title: {_similar: \$search}}}}, {title: {_similar: \$search}}, {user: {displayName: {_similar: \$search}}}]}, order_by: {votes_aggregate: {count: desc}}) {
    id
      title
      userId
      $_choiceResponseGraphQL
      user {
        id
        displayName
        profilePicUrl
      }
      hashtags {
        hashtag {
          id
          title
        }
      }
      votes(where: {userId: {_eq: \$userId}}, limit: 1) {
        choiceId
        userId
      }
  }
}
''';

const String getPoolsByHashtagQuery = '''
  query MyQuery(\$limit: Int = 6, \$offset: Int = 0, \$userId: String= "", \$hashtag: String) {
    pools(limit: \$limit, offset: \$offset, order_by: {votes_aggregate: {count: asc}, endDate: desc_nulls_last}, where: {hashtags: {hashtag: {title: {_eq: \$hashtag}}}}) {
      id
      title
      userId
      $_choiceResponseGraphQL
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
      votes(where: {userId: {_eq: \$userId}}, limit: 1) {
        choiceId
        userId
      }
    }
  }
''';

const String _poolResponseGraphQL = '''
      id
                title
                userId
                $_choiceResponseGraphQL
                user {
                  id
                  displayName
                  profilePicUrl
                }
                hashtags {
                  hashtag {
                    id
                    title
                  }
                }
''';

const String _choiceResponseGraphQL = '''
choices(order_by: {id: asc}) {
        title
        poolId
        id
        votes_aggregate {
                    aggregate {
                      count
                    }
                  }
      }
''';


