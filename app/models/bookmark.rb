class Bookmark < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
