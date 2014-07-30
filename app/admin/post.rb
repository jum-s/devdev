ActiveAdmin.register Post do

  index do
    selectable_column
    column :title
    column :updated_at
    actions
  end

  form do |texte|
    texte.inputs "Post" do
      texte.input :titre
      texte.input :text, as: :html_editor
    end
    texte.actions
  end
end
