class CreatePensees < ActiveRecord::Migration
  def change
    create_table :pensees do |t|
      t.text :text
      
      t.timestamps
    end
  end
end
