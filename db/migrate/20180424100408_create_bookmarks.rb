class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, foreign_key: true
      t.text :URL
      t.string :title
      t.string :category
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
