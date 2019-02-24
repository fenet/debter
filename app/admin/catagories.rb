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
    column "Products" do |c|
    	c.products.count
    end
    column :created_by
    column "Created At" do |c|
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
      f.input :desc, label: "Description"
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
          c.products.count
        end
        row :created_at
        row :updated_at
      end 
      
    end
    active_admin_comments
  end

  sidebar "Products In This Catagory", :only => :show do
    attributes_table_for catagory do
      
        catagory.products.each do |pro|
          row "Products" do |pro|
            pro.product_name
          end
        end
      
    end
  end

end
