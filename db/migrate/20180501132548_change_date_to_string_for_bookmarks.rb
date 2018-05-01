class ChangeDateToStringForBookmarks < ActiveRecord::Migration[5.1]
  def change
    change_column :bookmarks, :date, :string
  end
end
