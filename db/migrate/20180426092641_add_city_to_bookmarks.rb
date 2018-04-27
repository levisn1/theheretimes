class AddCityToBookmarks < ActiveRecord::Migration[5.1]
  def change
    add_column :bookmarks, :city, :string
  end
end
