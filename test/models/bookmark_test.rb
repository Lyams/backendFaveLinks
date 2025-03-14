require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  test "bookmark is valid with valid attributes" do
    bookmark = Bookmark.new(title: "Example", url: "http://example.com")
    assert bookmark.valid?
  end

  test "bookmark is not valid without a title" do
    bookmark = Bookmark.new(title: nil, url: "http://example.com")
    refute bookmark.valid?
    assert_not_nil bookmark.errors[:title]
  end

  test "bookmark is not valid without a url" do
    bookmark = Bookmark.new(title: "Example", url: nil)
    refute bookmark.valid?
    assert_not_nil bookmark.errors[:url]
  end

  test "bookmark is not valid with an invalid url format" do
    bookmark = Bookmark.new(title: "Example", url: "invalid-url")
    refute bookmark.valid?
    assert_not_nil bookmark.errors[:url]
  end

  test "bookmark is valid with a valid https url" do
    bookmark = Bookmark.new(title: "Example", url: "https://example.com")
    assert bookmark.valid?
  end

  test "insert valid bookmark directly into database" do
    Bookmark.connection.execute(
      "INSERT INTO bookmarks (title, url, created_at, updated_at) VALUES ('Valid Title', 'http://example.com', '#{Time.now}', '#{Time.now}')"
    )
    bookmark = Bookmark.find_by(title: "Valid Title")
    assert_not_nil bookmark
  end

  test "insert bookmark with null title raises error" do
    assert_raises(ActiveRecord::StatementInvalid) do
      Bookmark.connection.execute(
        "INSERT INTO bookmarks (title, url, created_at, updated_at) VALUES (NULL, 'http://example.com', '#{Time.now}', '#{Time.now}')"
      )
    end
  end

  test "insert bookmark with null url raises error" do
    assert_raises(ActiveRecord::StatementInvalid) do
      Bookmark.connection.execute(
        "INSERT INTO bookmarks (title, url, created_at, updated_at) VALUES ('Valid Title', NULL, '#{Time.now}', '#{Time.now}')"
      )
    end
  end
end
