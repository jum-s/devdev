class RemovePocketDateToAutopost < ActiveRecord::Migration
  def change
    remove_column :autoposts, :pocket_date, :datetime
    add_column :twtlinks, :has_video, :integer, default: 0
  end
end
