class AddTagToAutopost < ActiveRecord::Migration
  def change
    add_column :autoposts, :tag, :text
    add_column :autoposts, :sentiment, :integer
  end
end
