class AddLanguageToTwtlink < ActiveRecord::Migration
  def change
    add_column :twtlinks, :language, :string
  end
end
