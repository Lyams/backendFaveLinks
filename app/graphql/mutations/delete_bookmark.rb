module Mutations
  class DeleteBookmark < Mutations::BaseMutation
    argument :id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      bookmark = Bookmark.find_by(id: id)

      return { bookmark: nil, errors: [ "Bookmark not found" ] } if bookmark.nil?

      if bookmark.destroy
        { bookmark: nil, errors: [] }
      else
        { bookmark: bookmark, errors: bookmark.errors.full_messages }
      end
    end
  end
end
