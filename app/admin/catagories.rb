ActiveAdmin.register Catagory do
  permit_params  :name, :desc, :created_by

  csv do
    column :id
    column :name
    column "Description" do |d|
      d.desc
    end
    column :created_by
    column "Products in this catagory" do |c|
      c.products.count
    end
    column :created_at
    column :updated_at
  end

  index do
    selectable_column
    column "Catagory Name", :name
    column "Products", sortable: true do |c|
    	status_tag c.products.count, class: "total_sale"
    end
    column :created_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at
  filter :created_by, as: :select, collection: -> {
    AdminUser.all.map { |user| [user.full_name, user.id] }
  }

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.full_name}
      f.input :name, label: "Catagory Name"
      f.input :desc, label: "Description", :input_html => {:rows => 5, :cols => 20 }
    end
    f.actions
  end

  show title: :name do
    panel "Catagory" do
      attributes_table_for catagory do
        row :name
        row "Description" do |d|
          d.desc
        end
        row :created_by
        row "Products in this catagory" do |c|
          status_tag c.products.count, class: "total_sale"
        end
        row :created_at
        row :updated_at
      end

    end

    #active_admin_comments
  end
  action_item :new, only: :show do
    link_to 'New catagory', new_admin_catagory_path
  end

  sidebar "Products In This Catagory", :only => :show do
    table_for catagory.products do

      column "Product name" do |product|
        product.product_name
      end

    end
  end


end
