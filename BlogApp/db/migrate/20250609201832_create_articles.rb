class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.boolean :public, default: false
      t.integer :reports_count, default: 0
      t.boolean :archived, default: false
      t.string :image

      t.timestamps
    end

    add_index :articles, :public
    add_index :articles, :archived
    add_index :articles, :reports_count
  end
end