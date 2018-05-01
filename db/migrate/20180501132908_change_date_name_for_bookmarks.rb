class ChangeDateNameForBookmarks < ActiveRecord::Migration[5.1]
  def change
    rename_column :bookmarks, :date, :published
  end
end
