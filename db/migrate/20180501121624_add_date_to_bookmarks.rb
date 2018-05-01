class AddDateToBookmarks < ActiveRecord::Migration[5.1]
  def change
    add_column :bookmarks, :date, :date
  end
end
