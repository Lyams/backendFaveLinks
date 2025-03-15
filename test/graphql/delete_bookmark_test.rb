require "test_helper"

class GraphQL::DeleteBookmarkTest < ActionDispatch::IntegrationTest
  def perform_mutation(id:)
    query = <<-GRAPHQL
      mutation {
        deleteBookmark(input: { id: "#{id}" }) {
          bookmark {
            id
          }
          errors
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query }
    response.parsed_body
  end

  test "deletes an existing bookmark" do
    bookmark = Bookmark.create!(title: "Test Bookmark", url: "http://example.com")

    result = perform_mutation(id: bookmark.id)
    bookmark_data = result["data"]["deleteBookmark"]["bookmark"]
    errors = result["data"]["deleteBookmark"]["errors"]

    assert_nil bookmark_data
    assert_empty errors
    assert_not Bookmark.exists?(bookmark.id)
  end

  test "returns error when bookmark does not exist" do
    result = perform_mutation(id: "invalid-id")
    bookmark_data = result["data"]["deleteBookmark"]["bookmark"]
    errors = result["data"]["deleteBookmark"]["errors"]

    assert_nil bookmark_data
    assert_includes errors, "Bookmark not found"
  end
end
