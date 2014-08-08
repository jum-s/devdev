class CreateTwtlinks < ActiveRecord::Migration
  def change
    create_table :twtlinks do |t|
      t.string :url
      t.string :title
      t.text :text
      t.string :tag
      t.string :sentiment
      t.integer :word_count
      t.integer :sentiment

      t.timestamps
    end
  end
end
