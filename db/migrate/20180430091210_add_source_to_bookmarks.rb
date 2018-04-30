class AddSourceToBookmarks < ActiveRecord::Migration[5.1]
  def change
    add_column :bookmarks, :source, :string
  end
end
