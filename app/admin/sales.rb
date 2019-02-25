ActiveAdmin.register Sale do
permit_params :customer_name ,:phone_number ,:address ,:include_tax ,:type_of_sales ,:total_prce

  index do
    selectable_column
    column "Sales ID" do |sale|
    	sale.id
    end 
    column :customer_name 
    # column "Catagory" do |c|
    #   catagory = Catagory.find(c.catagory_id)
    #   catagory.name
    # end  
    # number_column :quanity
    column :type_of_sales
    column :include_tax
    number_column :total_prce, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :created_by
    column "Created At" do |c|
      c.created_at.strftime("%b %d, %Y")
    end 
    actions
  end


  filter :id
  filter :customer_name
  filter :total_prce, as: :numeric_range_filter

  form do |f|
  	f.semantic_errors
    f.inputs "New Sales", :multipart => true do
     f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.full_name}
    	# f.input :photo, :as => :file, :hint => f.product.photo.present? \
     #      ? image_tag(f.object.photo.url(:thumbnail))
     #      : content_tag(:span, "no cover page yet")
     #  f.input :photo_cache, :as => :hidden 
	    # f.input :product_name 
	    # f.input :description
	    # f.input :unit_price
	    # f.input :quanity
     #  f.input :serial_number, label: "Serial Number Or Any Identification"
	    # f.input :catagory_id, as: :search_select, url: admin_catagories_path,
     #      fields: [:name, :desc], display_name: 'name', minimum_input_length: 2,
     #      order_by: 'desc_asc'
      
      f.input :customer_name 
      f.input :phone_number 
      f.input :address
      f.input :type_of_sales, :as => :select, :collection => ["normal", "credit"], :include_blank => false
      f.input :include_tax
      
    end
    # f.has_many :tags, allow_destroy: true, new_record: true, sortable_start: 3 do |a|
    #   a.input :tag_name
    # end
    f.actions
  end
  show title: "sale" do
    panel "Sales" do
    	attributes_table_for sale do
    		row :id
        row :customer_name
        row :phone_number
        row :address
        row :type_of_sales
        row :include_tax
        number_row :total_prce, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
        row :created_by
        row :created_at
        row :updated_at
     	end	     
    end
    active_admin_comments
  end

end
