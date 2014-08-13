class AddLanguageToTwtlink < ActiveRecord::Migration
  def change
    add_column :twtlinks, :language, :string
    add_column :autoposts, :language, :string
  end
end
