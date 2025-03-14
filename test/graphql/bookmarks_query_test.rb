require "test_helper"

class GraphQL::BookmarksQueryTest < ActionDispatch::IntegrationTest
  def execute_query(query)
    post "/graphql", params: { query: query }
    JSON.parse(response.body)
  end

  test "query bookmarks returns all bookmarks" do
    query = <<-GRAPHQL
      query {
        bookmarks {
          id
          title
          url
        }
      }
    GRAPHQL

    result = execute_query(query)

    assert_equal 2, result["data"]["bookmarks"].size
    assert_equal [ bookmarks(:one).title, bookmarks(:two).title  ],
                 [ result["data"]["bookmarks"][0]["title"], result["data"]["bookmarks"][1]["title"] ].sort
    assert_equal [  bookmarks(:one).url, bookmarks(:two).url ],
                 [ result["data"]["bookmarks"][0]["url"], result["data"]["bookmarks"][1]["url"] ].sort
  end
end
