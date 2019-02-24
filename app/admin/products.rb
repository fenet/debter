ActiveAdmin.register Product do
permit_params :product_name,:description,:unit_price,:quanity, :photo, :photo_cache,:serial_number,:selling_price,:type_of_sales, :catagory_id, :created_by

  csv do
    column :id
    column :product_name
    column "Catagory" do |c|
      catagory = Catagory.find(c.catagory_id)
      catagory.name
    end     
    column :description
    column :unit_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :selling_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :quanity
    column "Serial Number Or Any Identification" do |s|
      s.serial_number
    end
    column :type_of_sales
    column :created_by
    column :created_at
    column :updated_at
  end

  index do
    selectable_column
    column :id
    column "Product Image" do |i|
    	if !i.photo.nil?
    		image_tag(i.photo.url(:thumbnail))
    	end
    end
    column "Product Name" do |n|
    	truncate(n.product_name, :line_width => 7)
    end 
    column "Catagory" do |c|
      catagory = Catagory.find(c.catagory_id)
      catagory.name
    end  
    number_column :quanity
    
    number_column :unit_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :created_by
    column "Created At" do |c|
      c.created_at.strftime("%b %d, %Y")
    end 
    actions
  end


  filter :product_name
  filter :id
  filter :catagory_id, as: :search_select_filter, url: proc { admin_catagories_path },
         fields: [:name, :description], display_name: 'name', minimum_input_length: 2,
         order_by: 'desc_asc'
  filter :quanity
  filter :unit_price, as: :numeric_range_filter
  # filter :catagory
  filter :created_at
  filter :created_by, as: :select, collection: -> {
    AdminUser.all.map { |user| [user.full_name, user.id] }
  }

  form do |f|
  	f.semantic_errors
    f.inputs "new product", :multipart => true do
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.full_name}
    	f.input :photo, :as => :file, :hint => f.product.photo.present? \
          ? image_tag(f.object.photo.url(:thumbnail))
          : content_tag(:span, "no cover page yet")
      # f.input :photo_cache, :as => :hidden 
	    f.input :product_name 
	    f.input :description
	    f.input :unit_price
	    f.input :quanity
	    f.input :catagory_id, as: :search_select, url: admin_catagories_path,
          fields: [:name, :desc], display_name: 'name', minimum_input_length: 2,
          order_by: 'desc_asc'
	    f.input :serial_number, label: "Serial Number Or Any Identification"
      f.input :type_of_sales,  :as => :select, :collection => ["Felxiable", "Fixed"], :include_blank => false
      f.input :selling_price
    end
    f.actions
  end


  show title: :product_name do
    panel "Product" do
    	attributes_table_for product do
    		row "Product Image" do |i|
    			if i.photo.present?
		    		image_tag(i.photo.url(:standard))
		    	end
		    end
        row "Catagory" do |c|
          catagory = Catagory.find(c.catagory_id)
          catagory.name
        end  
	     	row :product_name
	     	row :id
        row :description
	     	number_row :unit_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
	     	number_row :selling_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
	     	row :quanity
	     	row "Serial Number Or Any Identification" do |s|
          s.serial_number
      	end
        row :type_of_sales
        row :created_by
        row :created_at
        row :updated_at
     	end	
      active_admin_comments
    end
  end
end
