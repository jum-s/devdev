class AddTagToAutopost < ActiveRecord::Migration
  def change
    add_column :autoposts, :tag, :text
  end
end
