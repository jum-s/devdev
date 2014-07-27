class CreateAutoposts < ActiveRecord::Migration
  def change
    create_table :autoposts do |t|
      t.string :title
      t.text :excerpt
      t.text :text
      t.integer :word_count
      t.string :pid
      t.text :url
      t.datetime :pocket_date
      t.integer :has_video, default: 0 

      t.timestamps
    end
  end
end
