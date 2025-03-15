require "test_helper"

class GraphQL::CreateBookmarkTest < ActionDispatch::IntegrationTest
  def perform_mutation(title:, url:)
    query = <<-GRAPHQL
      mutation {
        createBookmark(input: { title: "#{title}", url: "#{url}" }) {
          bookmark {
            id
            title
            url
          }
          errors
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query }
    response.parsed_body
  end

  test "creates a bookmark with valid attributes" do
    assert_difference("Bookmark.count", 1) do
      result = perform_mutation(title: "Test Bookmark", url: "http://example.com")
      bookmark_data = result["data"]["createBookmark"]["bookmark"]

      assert_not_nil bookmark_data
      assert_equal "Test Bookmark", bookmark_data["title"]
      assert_equal "http://example.com", bookmark_data["url"]
      assert_empty result["data"]["createBookmark"]["errors"]
    end
  end

  test "returns errors for invalid attributes" do
    result = perform_mutation(title: "Invalid Bookmark", url: "invalid-url")
    bookmark_data = result["data"]["createBookmark"]["bookmark"]
    errors = result["data"]["createBookmark"]["errors"]

    assert_nil bookmark_data
    assert_includes errors, "Url is invalid"
  end
end
