class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.string :reason
      t.text :description

      t.timestamps
    end

    add_index :reports, [:user_id, :article_id], unique: true
  end
end