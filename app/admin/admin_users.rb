ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation,:full_name,:company_name,:tax_type,:role

  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end

  index do
    selectable_column
    column "FullName" do |u|
      truncate(u.full_name,  :length => 15)
    end
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :full_name
  filter :role
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :full_name
      f.input :role,  :as => :select, :collection => ["Owner", "Employee"], label: "Account Role", :include_blank => false
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :company_name
      f.input :tax_type,  :as => :select, :collection => ["VAT", "TOT"], label: "Tax Type", :include_blank => false
    end
    f.actions
  end

end
