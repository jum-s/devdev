ActiveAdmin.register Autopost do
  index do
    selectable_column
    column :title
    column :updated_at
    actions
  end
end
