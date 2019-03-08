ActiveAdmin.register Sale do
permit_params :customer_name ,:phone_number ,:address ,:include_tax , :created_by, :type_of_sales ,:total_prce, :down_payment, :fully_payed, product_items_attributes: [:id, :product_id, :selling_price,:quantity,:pre_quantity, :_destroy]


  csv do
    column "Products" do |sale|
      if !sale.product_ids.nil?
        sale.products.map { |e| e.product_name }.join(", ")
      end
    end    
    column "Total Products" do |s|
      s.products.count
    end
    column "Quantities" do |t|
      t.product_items.collect { |oi| oi.quantity}.sum
    end
    column :total_prce, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :include_tax
    column :type_of_sales
    column :down_payment, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column "Remaining Payment" do |py|
      payment= py.total_prce - py.down_payment
      number_to_currency payment, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    end
    column :fully_payed
    column :customer_name 
    column :phone_number
    column :address
    column :created_by
    column :created_at
    column :updated_at
  end

	controller do
     after_action :decrement_inventory_quantity, only: [:create]
     after_action :set_pre_quantity, only: [:create]
     after_action :update_inventory_quantity, only: [:update]
     before_action :show_page_title, only: [:show]

     private 
	    def update_inventory_quantity
	     	@sale.products.each do |product|
          product.product_items.each do |item|
            if 
              if !item.pre_quantity.nil? && (item.pre_quantity != item.quantity)
                item_quantity = (item.pre_quantity - item.quantity).abs
                quantity = product.quantity - item_quantity
                product.update_columns(quantity: quantity)
                item.update_columns(pre_quantity: item.quantity)  
              elsif item.pre_quantity.nil?
                quantity = product.quantity - item.quantity
                product.update_columns(quantity: quantity)
                item.update_columns(pre_quantity: item.quantity)  
              end
            end
          end
        end
	    end

      def set_pre_quantity
        @sale.product_items.each do |item|
          pre_quantity = item.quantity
          item.update_columns(pre_quantity: pre_quantity)
        end
      end

	    def decrement_inventory_quantity
	     	@sale.products.each do |product|
	     		product.product_items.each do |item|
  		     	quantity = product.quantity - item.quantity
  		     	product.update_columns(quantity: quantity)
	     		end
	     	end
	    end
      
      def show_page_title
        @page_title = "#{Sale.find(params[:id]).total_prce} ETB"
      end
  end
  
  index do
    selectable_column 
    column "Products" do |sale|
      if !sale.product_ids.nil?
        sale.products.limit(4).map { |e| e.product_name }.join(", ")
      end
    end
    column "Quantities" do |t|
      t.product_items.collect { |oi| oi.quantity}.sum
    end
    # list_column :product_items
    # number_column :quantity
    column :type_of_sales do |s|
      status_tag s.type_of_sales
    end
    # toggle_bool_column  :include_tax
    column :customer_name do |c|
      truncate( c.customer_name, :line_width => 7)
    end
    number_column :total_prce, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
    column :created_by
    column "Created" do |c|
      c.created_at.strftime("%b %d, %Y")
    end 
    actions
  end

  filter :products, collection: -> {
    Product.all.map { |product| [product.product_name, product.id] }
  }
  filter :customer_name
  filter :total_prce, as: :numeric_range_filter
  filter :type_of_sales, as: :select, :collection => ["Normal", "Credit","Down Sales"]
  filter :created_at
  filter :created_by, as: :select, collection: -> {
    AdminUser.all.map { |user| [user.full_name, user.id] }
  }

  scope :total_sold
  scope :recently_sold
  scope :normal_sale
  scope :credit_sale
  scope :down_sale

  form do |f|
  	f.semantic_errors
    f.inputs "New Sales", :multipart => true do

     f.input :created_by, as: :hidden, :input_html => { :value => current_admin_user.full_name}
      f.input :customer_name 
      f.input :phone_number 
      f.input :address
      f.input :type_of_sales, :as => :select, :collection => ["Normal", "Credit","Down Sales"], :include_blank => false
      f.input :down_payment
      f.input :fully_payed
      f.input :include_tax
      
    end
    f.has_many :product_items,remote: true , allow_destroy: true, new_record: true do |a|
      	a.input :product_id, as: :search_select, url: admin_products_path,
          fields: [:product_name, :id], display_name: 'product_name', minimum_input_length: 3,
          order_by: 'id_asc'

	      a.input :selling_price, :required => true
        # add max value 
	      a.input :quantity, :required => true, min: 1
	      
	      a.label :_destroy
    end
    f.actions
  end
  show do
    panel "Sales" do
    	attributes_table_for sale do
    		row :id
        
        number_row :total_prce, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
        number_row "Total Products" do |s|
          s.products.count
        end
        number_row "Quantities" do |t|
          t.product_items.collect { |oi| oi.quantity}.sum
        end
        row :type_of_sales do |s|
          status_tag s.type_of_sales
        end
        if sale.type_of_sales == "Down Sales"
          number_row :down_payment, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
          row "Remaining Payment" do |py|
            payment= py.total_prce - py.down_payment
            number_to_currency payment, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
          end
          row :fully_payed

        end
        row :include_tax
        row :created_by
        row :created_at
        row :updated_at
     	end
           
    end
    panel "Products" do
      table_for sale.product_items.order('created_at ASC') do
          column "Products" do |item|
            link_to image_tag(item.product.photo.url(:small_thumbnail)), [ :admin, item.product ]
          end
          column "Products Name" do |item|
            link_to item.product.product_name, [ :admin, item.product ]
          end
          column "Catagory" do |item|
            catagory = Catagory.find(item.product.catagory_id)
            catagory.name
          end
          column "Unit Price" do |item|
            number_to_currency item.product.unit_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
          end 

          column " Initial Selling Price" do |item|
            number_to_currency item.product.selling_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
          end
          column "Sold Price" do |item|
            number_to_currency item.selling_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
          end 
          column :quantity  
          column "Total" do |item|
            total = item.selling_price * item.quantity
            number_to_currency total, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
          end 
          column "added" do |item|
            item.created_at.strftime("%b %d, %Y")
          end 
      end
    end
    active_admin_comments
  end
  sidebar "Customer Information", :only => :show do
    attributes_table_for sale do
      row :customer_name
      row :phone_number
      row :address
    end
  end

end
