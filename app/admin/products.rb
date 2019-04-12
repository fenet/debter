ActiveAdmin.register Product do
  menu label: "Stock"
permit_params :product_name,:description,:unit_price,:quantity, :photo, :photo_cache,:serial_number,:selling_price,:type_of_sales, :catagory_id, :created_by, tags_attributes: [:id, :tag_name, :_destroy]

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
    column :quantity
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

    		image_tag(i.photo.url(:small_thumbnail)) if i.photo.present?

    end
    column "Product Name", sortable: true do |n|
    	truncate(n.product_name, :line_width => 7)
    end
    column "Catagory", sortable: true do |c|
      catagory = Catagory.find(c.catagory_id)
      catagory.name
    end
    number_column :quantity

    number_column :unit_price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :created_by
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end


  filter :product_name
  filter :id
  filter :serial_number
  filter :catagory_id, as: :search_select_filter, url: proc { admin_catagories_path },
         fields: [:name, :description], display_name: 'name', minimum_input_length: 2,
         order_by: 'desc_asc'
  filter :quantity
  filter :unit_price, as: :numeric_range_filter
  # filter :catagory
  filter :created_at
  filter :created_by, as: :select, collection: -> {
    AdminUser.all.map { |user| [user.full_name, user.id] }
  }
   filter :tags, as: :select, collection: -> { Tag.all.map { |tag| [tag.tag_name, tag.id] }
  }

  scope :total_stock
  scope :recently_added

  form do |f|
  	f.semantic_errors
    f.inputs "new product", :multipart => true do
      f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.full_name}
    	f.input :photo, :as => :file, :hint => f.product.photo.present? \
          ? image_tag(f.object.photo.url(:thumbnail))
          : content_tag(:span, "no cover page yet")
      f.input :photo_cache, :as => :hidden
	    f.input :product_name
	    f.input :description, :input_html => {:rows => 5, :cols => 20 }
	    f.input :unit_price
	    f.input :quantity
      f.input :serial_number, label: "Serial Number Or Any Identification"
	    f.input :catagory_id, as: :search_select, url: admin_catagories_path,
          fields: [:name, :desc], display_name: 'name', minimum_input_length: 2,
          order_by: 'desc_asc'
      f.has_many :tags, allow_destroy: true, new_record: true, sortable_start: 3 do |a|
          a.input :tag_name
        end
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
	     	row :quantity
	     	row "Serial Number Or Any Identification" do |s|
          s.serial_number
      	end
        row :type_of_sales
        row :created_by
        row :created_at
        row :updated_at
     	end

    end
    #active_admin_comments
  end

  action_item :new, only: :show do
    link_to 'New Product', new_admin_product_path
  end

  sidebar "Tags In This Product", :only => :show do
    table_for product.tags do

      column "Tags" do |tag|
        tag.tag_name
      end

    end
  end
end
