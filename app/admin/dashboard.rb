ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    tabs do
      tab "Daily Report" do

        columns do
          column do
            panel "Daily Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  status_tag d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(type_of_sales: "Down Sales").count, class: "down_sales"
                end
                row "Credit Sales" do |d|
                  status_tag d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(type_of_sales: "Credit").count, class: "credit"
                end
                row "Normal Sales" do |d|
                  status_tag d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(type_of_sales: "Normal").count, class: "normal"
                end
                row "Total Sales" do |d|
                  # total_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).sum(:total_price)
                  status_tag d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count, class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Daily Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  total_down_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(type_of_sales: "Down Sales").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_down_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "down_sales"
                end
                row "Credit Sales" do |d|
                  total_credit_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(type_of_sales: "Credit").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_credit_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "credit"
                end
                row "Normal Sales" do |d|
                  total_normal_sale = Sale.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(type_of_sales: "Normal").map{|e| e.total_price}.sum

                  status_tag number_to_currency( total_normal_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
                row "Total Sales" do |d|
                  total_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Daily Sales Report" do
              attributes_table_for Sale do
                row "Gross Sales" do |d|
                  total_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end

                # row "Sales with out tax" do |d|
                #   total_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: false).map{|e| e.total_price}.sum
                #   status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end
                # row "Sales with tax" do |d|
                #   tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e|
                #     if current_admin_user.tax_type == "VAT"
                #       e.total_price * 0.15
                #     elsif current_admin_user.tax_type == "TOT"
                #       e.total_price * 0.02
                #     end
                #   }.sum
                #   total_sale = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e| e.total_price}.sum
                #   after_tax = (total_sale - tax).abs
                #   status_tag number_to_currency( after_tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end

                row "tax" do |d|
                  tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  status_tag number_to_currency( tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "net sales" do |d|
                  total_sale_with_out_tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Expense" do |d|
                  expense = Expense.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.price}.sum
                  status_tag number_to_currency( expense, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Profit" do |d|
                  total_sale_with_out_tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  expense = Expense.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.price}.sum

                  total_unit_price = ProductItem.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.product.unit_price * e.quantity}.sum
                  profit = (total_sale - total_unit_price) - expense

                  status_tag number_to_currency( profit, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "7 days Sales Report Graph" do
              product = ProductItem.where("created_at >= ?", 1.week.ago)
              line_chart product.group_by_day(:created_at).count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, 7 days Sales Report Graph"}, xtitle: "Time", ytitle: "Product Sold", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
          column do
            panel "Daily Type Of Sales Report Chart" do
              sale = Sale.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
              pie_chart sale.group(:type_of_sales).count , colors: ["#8daa92", "#e29b20", "#d45f53"] ,download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Daily Type Of Sales Report Chart"}, donut: true, defer: true, messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Stock Report" do
              attributes_table_for Sale do
                row "Total Product In Stock" do |d|
                  status_tag Product.count, class: "normal"
                end
                row "Total Catagory" do |d|
                  status_tag Catagory.count, class: "normal"
                end
                row "Total Stock" do |d|
                  status_tag Product.pluck(:quantity).sum, class: "normal"
                end
              end
            end
          end
          column do
            panel "Daily Stock Activities (Product X Quantity)" do
              attributes_table_for Product do
                row "Added Products" do |pro|
                  status_tag pro.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.quantity}.sum, class: "normal"
                end
                row "Sold Products" do |pro|
                  # ProductItem.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.quantity}.sum
                  status_tag ProductItem.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).pluck(:quantity).sum, class: "credit"
                end
                row "Total Stock" do |pro|
                  total_product = pro.pluck(:quantity).sum
                  status_tag total_product, class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Daily Stock Report (Price X Quantity)" do
              attributes_table_for Product do
                row "Added Product" do |pro|
                  added_product = pro.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.unit_price * e.quantity}.sum
                  status_tag number_to_currency( added_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
                end
                row "Sold Product" do |pro|
                  sold_product = ProductItem.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).map{|e| e.selling_price * e.quantity}.sum
                  status_tag number_to_currency( sold_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Selling Price X Quantity)'
                end
                row "Total Stock" do |pro|
                  total_product = pro.all.map{|e| e.quantity * e.unit_price}.sum
                  status_tag number_to_currency( total_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
                end
              end
            end
          end
        end
        columns do
          column do
            panel "7 Days Stock Report Graph" do
              product =Product.where("created_at >= ?", 1.week.ago)
              line_chart product.group_by_day(:created_at).count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, 7 Days Stock Report Graph"}, messages: {empty: "There Is No Data", library: {backgroundColor: "#fff"}}, xtitle: "Time", ytitle: "Added Product"
            end
          end
        end
        columns do
          column do
            panel "Recent Added Users" do
              if !(AdminUser.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count == 0)
                table_for AdminUser.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order("created_at desc").limit(10).each do |_user|
                  column(:full_name)    { |user| link_to(user.full_name, admin_admin_user_path(user)) }
                  column(:role)    { |user| user.role }
                  column(:sign_in_count)    { |user| user.sign_in_count}
                  column("Created At" )   { |user| user.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW USER ADDED TODAY"
                end
                  # actions defaults: true do |foo|

                  #   link_to "Add New User", new_admin_admin_user_path(foo)

                  # end
              end
            end
          end
          column do
            panel "Recent Added Expense" do
              if !(Expense.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count == 0)
                table_for Expense.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order("created_at desc").limit(10).each do |_expense|
                  column(:expense)    { |expense| link_to(truncate(expense.expense,  :length => 15), admin_expense_path(expense)) }
                  number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
                  column :created_by

                  column("Created At" )   { |expense| expense.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW EXPENSE ADDED TODAY"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Recent Added To Stock" do
              if !(Product.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count == 0)
                table_for Product.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order("created_at desc").limit(10) do
                  column "Product Image" do |i|
                    image_tag(i.photo.url(:small_thumbnail)) if i.photo.present?
                  end
                  column("Product Name") { |product| link_to(truncate(product.product_name, :length => 20), admin_product_path(product)) }
                  column(:catagory) { |product| product.catagory}
                  column(:quantity) { |product| product.quantity}
                  column(:unit_price)   { |product| number_to_currency(product.unit_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |product| product.created_by }
                  column("Created At" )   { |product| product.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO NEW PRODUCT ADDED TO STOCK TODAY"
                end
              end
            end
          end
          column do
            panel "Recent Sold To Products" do
              if !(Sale.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count == 0)
                table_for Sale.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order("created_at desc").limit(10) do
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
                  column :type_of_sales
                  column(:total_price)   { |sale| number_to_currency(sale.total_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |sale| sale.created_by }
                  column("Created At" )   { |sale| sale.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO PRODUCT SOLD TODAY"
                end
              end
            end
          end
        end
      end

      tab "Weekly Report" do

        columns do
          column do
            panel "Weekly Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.week.ago).where(type_of_sales: "Down Sales").count, class: "down_sales"
                end
                row "Credit Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.week.ago).where(type_of_sales: "Credit").count, class: "credit"
                end
                row "Normal Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.week.ago).where(type_of_sales: "Normal").count, class: "normal"
                end
                row "Total Sales" do |d|
                  # total_sale = d.where('created_at >= ?', 1.week.ago).sum(:total_price)
                  status_tag d.where('created_at >= ?', 1.week.ago).count, class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Weekly Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  total_down_sale = d.where('created_at >= ?', 1.week.ago).where(type_of_sales: "Down Sales").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_down_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "down_sales"
                end
                row "Credit Sales" do |d|
                  total_credit_sale = d.where('created_at >= ?', 1.week.ago).where(type_of_sales: "Credit").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_credit_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "credit"
                end
                row "Normal Sales" do |d|
                  total_normal_sale = Sale.where('created_at >= ?', 1.week.ago).where(type_of_sales: "Normal").map{|e| e.total_price}.sum

                  status_tag number_to_currency( total_normal_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
                row "Total Sales" do |d|
                  total_sale = d.where('created_at >= ?', 1.week.ago).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Weekly Sales Report" do
              attributes_table_for Sale do
                row "Gross Sales" do |d|
                  total_sale = d.where('created_at >= ?', 1.week.ago).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end

                # row "Sales with out tax" do |d|
                #   total_sale = d.where('created_at >= ?', 1.week.ago).where(include_tax: false).map{|e| e.total_price}.sum
                #   status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end
                # row "Sales with tax" do |d|
                #   tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e|
                #     if current_admin_user.tax_type == "VAT"
                #       e.total_price * 0.15
                #     elsif current_admin_user.tax_type == "TOT"
                #       e.total_price * 0.02
                #     end
                #   }.sum
                #   total_sale = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e| e.total_price}.sum
                #   after_tax = (total_sale - tax).abs
                #   status_tag number_to_currency( after_tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end

                row "tax" do |d|
                  tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  status_tag number_to_currency( tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "net sales" do |d|
                  total_sale_with_out_tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Expense" do |d|
                  expense = Expense.where('created_at >= ?', 1.week.ago).map{|e| e.price}.sum
                  status_tag number_to_currency( expense, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Profit" do |d|
                  total_sale_with_out_tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where('created_at >= ?', 1.week.ago).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  expense = Expense.where('created_at >= ?', 1.week.ago).map{|e| e.price}.sum

                  total_unit_price = ProductItem.where('created_at >= ?', 1.week.ago).map{|e| e.product.unit_price * e.quantity}.sum
                  profit = (total_sale - total_unit_price) - expense

                  status_tag number_to_currency( profit, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Weekly Sales Report Graph" do
              product = ProductItem.where("created_at >= ?", 1.week.ago)

              column_chart product.group_by_day_of_week(:created_at, format: "%a").count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Weekly Sales Report Graph"}, xtitle: "Time", ytitle: "Product Sold", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
          column do
            panel "Weekly Type Of Sales Report Chart" do
              sale = Sale.where('created_at >= ?', 1.week.ago)
              pie_chart sale.group(:type_of_sales).count , colors: ["#8daa92", "#e29b20", "#d45f53"] ,download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Weekly Type Of Sales Report Chart"}, donut: true, defer: true, messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Stock Report" do
              attributes_table_for Sale do
                row "Total Product In Stock" do |d|
                  status_tag Product.count, class: "normal"
                end
                row "Total Catagory" do |d|
                  status_tag Catagory.count, class: "normal"
                end
                row "Total Stock" do |d|
                  status_tag Product.pluck(:quantity).sum, class: "normal"
                end
              end
            end
          end
          column do
            panel "Weekly Stock Activities (Product X Quantity)" do
              attributes_table_for Product do
                row "Added Products" do |pro|
                  status_tag pro.where('created_at >= ?', 1.week.ago).map{|e| e.quantity}.sum, class: "normal"
                end
                row "Sold Products" do |pro|
                  # ProductItem.where('created_at >= ?', 1.week.ago).map{|e| e.quantity}.sum
                  status_tag ProductItem.where('created_at >= ?', 1.week.ago).pluck(:quantity).sum, class: "credit"
                end
                row "Total Stock" do |pro|
                 total_product = pro.pluck(:quantity).sum
                 status_tag total_product, class: "total_sale"
                end
              end
            end
          end
         column do
            panel "Weekly Stock Report (Price X Quantity)" do
              attributes_table_for Product do
                row "Added Product" do |pro|
                  added_product = pro.where('created_at >= ?', 1.week.ago).map{|e| e.unit_price * e.quantity}.sum
                  status_tag number_to_currency( added_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
                end
                row "Sold Product" do |pro|
                  sold_product = ProductItem.where('created_at >= ?', 1.week.ago).map{|e| e.selling_price * e.quantity}.sum
                  status_tag number_to_currency( sold_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Selling Price X Quantity)'
                end
                row "Total Stock" do |pro|
                  total_product = pro.all.map{|e| e.quantity * e.unit_price}.sum
                  status_tag number_to_currency( total_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Weekly Stock Report Graph" do
              product =Product.where("created_at >= ?", 1.week.ago)

              column_chart product.group_by_day_of_week(:created_at, format: "%a").count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Weekly Stock Report Graph"}, xtitle: "Time", ytitle: "Added Product", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Recent Added Users" do
              if !(AdminUser.where('created_at >= ?', 1.week.ago).count == 0)
                table_for AdminUser.where('created_at >= ?', 1.week.ago).order("created_at desc").limit(10).each do |_user|
                  column(:full_name)    { |user| link_to(user.full_name, admin_admin_user_path(user)) }
                  column(:role)    { |user| user.role }
                  column(:sign_in_count)    { |user| user.sign_in_count}
                  column("Created At" )   { |user| user.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW USER ADDED TODAY"
                end
                # actions defaults: true do |foo|

                #   link_to "Add New User", new_admin_admin_user_path(foo)

                # end
              end
            end
          end
          column do
            panel "Recent Added Expense" do
              if !(Expense.where('created_at >= ?', 1.week.ago).count == 0)
                table_for Expense.where('created_at >= ?', 1.week.ago).order("created_at desc").limit(10).each do |_expense|
                  column(:expense)    { |expense| link_to(truncate(expense.expense,  :length => 15), admin_expense_path(expense)) }
                  number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
                  column :created_by

                  column("Created At" )   { |expense| expense.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW EXPENSE ADDED TODAY"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Recent Added To Stock" do
              if !(Product.where('created_at >= ?', 1.week.ago).count == 0)
                table_for Product.where('created_at >= ?', 1.week.ago).order("created_at desc").limit(10) do
                  column "Product Image" do |i|
                    image_tag(i.photo.url(:small_thumbnail)) if i.photo.present?
                  end
                  column("Product Name") { |product| link_to(truncate(product.product_name, :length => 20), admin_product_path(product)) }
                  column(:catagory) { |product| product.catagory}
                  column(:quantity) { |product| product.quantity}
                  column(:unit_price)   { |product| number_to_currency(product.unit_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |product| product.created_by }
                  column("Created At" )   { |product| product.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO NEW PRODUCT ADDED TO STOCK TODAY"
                end
              end
            end
          end
          column do
            panel "Recent Sold To Products" do
              if !(Sale.where('created_at >= ?', 1.week.ago).count == 0)
                table_for Sale.where('created_at >= ?', 1.week.ago).order("created_at desc").limit(10) do
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
                  column :type_of_sales
                  column(:total_price)   { |sale| number_to_currency(sale.total_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |sale| sale.created_by }
                  column("Created At" )   { |sale| sale.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO PRODUCT SOLD TODAY"
                end
              end
            end
          end
        end
      end

      tab "Monthly Report" do
        columns do
          column do
            panel "Monthly Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.month.ago).where(type_of_sales: "Down Sales").count, class: "down_sales"
                end
                row "Credit Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.month.ago).where(type_of_sales: "Credit").count, class: "credit"
                end
                row "Normal Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.month.ago).where(type_of_sales: "Normal").count, class: "normal"
                end
                row "Total Sales" do |d|
                  # total_sale = d.where('created_at >= ?', 1.month.ago).sum(:total_price)
                  status_tag d.where('created_at >= ?', 1.month.ago).count, class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Monthly Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  total_down_sale = d.where('created_at >= ?', 1.month.ago).where(type_of_sales: "Down Sales").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_down_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "down_sales"
                end
                row "Credit Sales" do |d|
                  total_credit_sale = d.where('created_at >= ?', 1.month.ago).where(type_of_sales: "Credit").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_credit_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "credit"
                end
                row "Normal Sales" do |d|
                  total_normal_sale = Sale.where('created_at >= ?', 1.month.ago).where(type_of_sales: "Normal").map{|e| e.total_price}.sum

                  status_tag number_to_currency( total_normal_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
                row "Total Sales" do |d|
                  total_sale = d.where('created_at >= ?', 1.month.ago).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Monthly Sales Report" do
              attributes_table_for Sale do
                row "Gross Sales" do |d|
                  total_sale = d.where('created_at >= ?', 1.month.ago).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end

                # row "Sales with out tax" do |d|
                #   total_sale = d.where('created_at >= ?', 1.month.ago).where(include_tax: false).map{|e| e.total_price}.sum
                #   status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end
                # row "Sales with tax" do |d|
                #   tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e|
                #     if current_admin_user.tax_type == "VAT"
                #       e.total_price * 0.15
                #     elsif current_admin_user.tax_type == "TOT"
                #       e.total_price * 0.02
                #     end
                #   }.sum
                #   total_sale = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e| e.total_price}.sum
                #   after_tax = (total_sale - tax).abs
                #   status_tag number_to_currency( after_tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end

                row "tax" do |d|
                  tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  status_tag number_to_currency( tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "net sales" do |d|
                  total_sale_with_out_tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Expense" do |d|
                  expense = Expense.where('created_at >= ?', 1.month.ago).map{|e| e.price}.sum
                  status_tag number_to_currency( expense, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Profit" do |d|
                  total_sale_with_out_tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where('created_at >= ?', 1.month.ago).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  expense = Expense.where('created_at >= ?', 1.month.ago).map{|e| e.price}.sum

                  total_unit_price = ProductItem.where('created_at >= ?', 1.month.ago).map{|e| e.product.unit_price * e.quantity}.sum
                  profit = (total_sale - total_unit_price) - expense

                  status_tag number_to_currency( profit, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Monthly Sales Report Graph" do
              product = ProductItem.where("created_at >= ?", 1.month.ago)

              line_chart product.group_by_day(:created_at, format: "%d").count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Monthly Sales Report Graph"}, xtitle: "Days", ytitle: "Product Sold", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
          column do
            panel "Monthly Type Of Sales Report Chart" do
              sale = Sale.where('created_at >= ?', 1.month.ago)
              pie_chart sale.group(:type_of_sales).count , colors: ["#8daa92", "#e29b20", "#d45f53"] ,download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Monthly Type Of Sales Report Chart"}, donut: true, defer: true, messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Stock Report" do
              attributes_table_for Sale do
                row "Total Product In Stock" do |d|
                  status_tag Product.count, class: "normal"
                end
                row "Total Catagory" do |d|
                  status_tag Catagory.count, class: "normal"
                end
                row "Total Stock" do |d|
                  status_tag Product.pluck(:quantity).sum, class: "normal"
                end
              end
            end
          end
          column do
            panel "Monthly Stock Activities (Product X Quantity)" do
              attributes_table_for Product do
                row "Added Products" do |pro|
                  status_tag pro.where('created_at >= ?', 1.month.ago).map{|e| e.quantity}.sum, class: "normal"
                end
                row "Sold Products" do |pro|
                  # ProductItem.where('created_at >= ?', 1.month.ago).map{|e| e.quantity}.sum
                  status_tag ProductItem.where('created_at >= ?', 1.month.ago).pluck(:quantity).sum, class: "credit"
                end
                row "Total Stock" do |pro|
                 total_product = pro.pluck(:quantity).sum
                 status_tag total_product, class: "total_sale"
               end
              end
            end
          end
          column do
            panel "Monthly Stock Report (Price X Quantity)" do
              attributes_table_for Product do
                row "Added Product" do |pro|
                  added_product = pro.where('created_at >= ?', 1.month.ago).map{|e| e.unit_price * e.quantity}.sum
                  status_tag number_to_currency( added_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
                end
                row "Sold Product" do |pro|
                  sold_product = ProductItem.where('created_at >= ?', 1.month.ago).map{|e| e.selling_price * e.quantity}.sum
                  status_tag number_to_currency( sold_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Selling Price X Quantity)'
                end
                row "Total Stock" do |pro|
                  total_product = pro.all.map{|e| e.quantity * e.unit_price}.sum
                  status_tag number_to_currency( total_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Monthly Stock Report Graph" do
                product =Product.where("created_at >= ?", 1.month.ago)
                line_chart product.group_by_day(:created_at, format: "%d").count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Monthly Stock Report Graph"}, xtitle: "Days", ytitle: "Added Product", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Recent Added Users" do
              if !(AdminUser.where('created_at >= ?', 1.month.ago).count == 0)
                table_for AdminUser.where('created_at >= ?', 1.month.ago).order("created_at desc").limit(10).each do |_user|
                  column(:full_name)    { |user| link_to(user.full_name, admin_admin_user_path(user)) }
                  column(:role)    { |user| user.role }
                  column(:sign_in_count)    { |user| user.sign_in_count}
                  column("Created At" )   { |user| user.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW USER ADDED TODAY"
                end
                # actions defaults: true do |foo|

                #   link_to "Add New User", new_admin_admin_user_path(foo)

                # end
              end
            end
          end
          column do
            panel "Recent Added Expense" do
              if !(Expense.where('created_at >= ?', 1.month.ago).count == 0)
                table_for Expense.where('created_at >= ?', 1.month.ago).order("created_at desc").limit(10).each do |_expense|
                  column(:expense)    { |expense| link_to(truncate(expense.expense,  :length => 15), admin_expense_path(expense)) }
                  number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
                  column :created_by

                  column("Created At" )   { |expense| expense.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW EXPENSE ADDED TODAY"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Recent Added To Stock" do
              if !(Product.where('created_at >= ?', 1.month.ago).count == 0)
                table_for Product.where('created_at >= ?', 1.month.ago).order("created_at desc").limit(10) do
                  column "Product Image" do |i|
                    image_tag(i.photo.url(:small_thumbnail)) if i.photo.present?
                  end
                  column("Product Name") { |product| link_to(truncate(product.product_name, :length => 20), admin_product_path(product)) }
                  column(:catagory) { |product| product.catagory}
                  column(:quantity) { |product| product.quantity}
                  column(:unit_price)   { |product| number_to_currency(product.unit_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |product| product.created_by }
                  column("Created At" )   { |product| product.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO NEW PRODUCT ADDED TO STOCK TODAY"
                end
              end
            end
          end
          column do
            panel "Recent Sold To Products" do
              if !(Sale.where('created_at >= ?', 1.month.ago).count == 0)
                table_for Sale.where('created_at >= ?', 1.month.ago).order("created_at desc").limit(10) do
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
                  column :type_of_sales
                  column(:total_price)   { |sale| number_to_currency(sale.total_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |sale| sale.created_by }
                  column("Created At" )   { |sale| sale.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO PRODUCT SOLD TODAY"
                end
              end
            end
          end
        end
      end

      tab "Yearly Report" do

        columns do
          column do
            panel "Yearly Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.year.ago).where(type_of_sales: "Down Sales").count, class: "down_sales"
                end
                row "Credit Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.year.ago).where(type_of_sales: "Credit").count, class: "credit"
                end
                row "Normal Sales" do |d|
                  status_tag d.where('created_at >= ?', 1.year.ago).where(type_of_sales: "Normal").count, class: "normal"
                end
                row "Total Sales" do |d|
                  # total_sale = d.where('created_at >= ?', 1.year.ago).sum(:total_price)
                  status_tag d.where('created_at >= ?', 1.year.ago).count, class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Yearly Sales Report (Type Of Sales)" do
              attributes_table_for Sale do
                row "Down Sales" do |d|
                  total_down_sale = d.where('created_at >= ?', 1.year.ago).where(type_of_sales: "Down Sales").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_down_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "down_sales"
                end
                row "Credit Sales" do |d|
                  total_credit_sale = d.where('created_at >= ?', 1.year.ago).where(type_of_sales: "Credit").map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_credit_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "credit"
                end
                row "Normal Sales" do |d|
                  total_normal_sale = Sale.where('created_at >= ?', 1.year.ago).where(type_of_sales: "Normal").map{|e| e.total_price}.sum

                  status_tag number_to_currency( total_normal_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
                row "Total Sales" do |d|
                  total_sale = d.where('created_at >= ?', 1.year.ago).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
              end
            end
          end
          column do
            panel "Yearly Sales Report" do
              attributes_table_for Sale do
                row "Gross Sales" do |d|
                  total_sale = d.where('created_at >= ?', 1.year.ago).map{|e| e.total_price}.sum
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end

                # row "Sales with out tax" do |d|
                #   total_sale = d.where('created_at >= ?', 1.year.ago).where(include_tax: false).map{|e| e.total_price}.sum
                #   status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end
                # row "Sales with tax" do |d|
                #   tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e|
                #     if current_admin_user.tax_type == "VAT"
                #       e.total_price * 0.15
                #     elsif current_admin_user.tax_type == "TOT"
                #       e.total_price * 0.02
                #     end
                #   }.sum
                #   total_sale = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e| e.total_price}.sum
                #   after_tax = (total_sale - tax).abs
                #   status_tag number_to_currency( after_tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                # end

                row "tax" do |d|
                  tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  status_tag number_to_currency( tax, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "net sales" do |d|
                  total_sale_with_out_tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  status_tag number_to_currency( total_sale, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Expense" do |d|
                  expense = Expense.where('created_at >= ?', 1.year.ago).map{|e| e.price}.sum
                  status_tag number_to_currency( expense, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "total_sale"
                end
                row "Profit" do |d|
                  total_sale_with_out_tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: false).map{|e| e.total_price}.sum
                  tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e|
                    if current_admin_user.tax_type == "VAT"
                      e.total_price * 0.15
                    elsif current_admin_user.tax_type == "TOT"
                      e.total_price * 0.02
                    end
                  }.sum
                  total_sale_with_tax = d.where('created_at >= ?', 1.year.ago).where(include_tax: true).map{|e| e.total_price}.sum
                  after_tax = (total_sale_with_tax - tax).abs
                  total_sale = total_sale_with_out_tax + after_tax
                  expense = Expense.where('created_at >= ?', 1.year.ago).map{|e| e.price}.sum

                  total_unit_price = ProductItem.where('created_at >= ?', 1.year.ago).map{|e| e.product.unit_price * e.quantity}.sum
                  profit = (total_sale - total_unit_price) - expense

                  status_tag number_to_currency( profit, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2), class: "normal"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Yearly Sales Report Graph" do
              product = ProductItem.where("created_at >= ?", 1.year.ago)
              line_chart ProductItem.group_by_month_of_year(:created_at, format: "%b").count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Yearly Sales Report Graph"}, xtitle: "Months", ytitle: "Product Sold", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
          column do
            panel "Yearly Type Of Sales Report Chart" do
              sale = Sale.where('created_at >= ?', 1.year.ago)
              pie_chart sale.group(:type_of_sales).count , colors: ["#8daa92", "#e29b20", "#d45f53"] ,download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Yearly Type Of Sales Report Chart"}, donut: true, defer: true, messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Stock Report" do
              attributes_table_for Sale do
                row "Total Product In Stock" do |d|
                  status_tag Product.count, class: "normal"
                end
                row "Total Catagory" do |d|
                  status_tag Catagory.count, class: "normal"
                end
                row "Total Stock" do |d|
                  status_tag Product.pluck(:quantity).sum, class: "normal"
                end
              end
            end
          end
          column do
            panel "Yearly Stock Activities (Product X Quantity)" do
              attributes_table_for Product do
                row "Added Products" do |pro|
                  status_tag pro.where('created_at >= ?', 1.year.ago).map{|e| e.quantity}.sum, class: "normal"
                end
                row "Sold Products" do |pro|
                  # ProductItem.where('created_at >= ?', 1.year.ago).map{|e| e.quantity}.sum
                  status_tag ProductItem.where('created_at >= ?', 1.year.ago).pluck(:quantity).sum, class: "credit"
                end
                row "Total Stock" do |pro|
                 total_product = pro.pluck(:quantity).sum
                 status_tag total_product, class: "total_sale"
               end
            end
          end
         end
         column do
          panel "Yearly Stock Report (Price X Quantity)" do
            attributes_table_for Product do
              row "Added Product" do |pro|
                added_product = pro.where('created_at >= ?', 1.year.ago).map{|e| e.unit_price * e.quantity}.sum
                status_tag number_to_currency( added_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
              end
              row "Sold Product" do |pro|
                sold_product = ProductItem.where('created_at >= ?', 1.year.ago).map{|e| e.selling_price * e.quantity}.sum
                status_tag number_to_currency( sold_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Selling Price X Quantity)'
              end
              row "Total Stock" do |pro|
                total_product = pro.all.map{|e| e.quantity * e.unit_price}.sum
                status_tag number_to_currency( total_product, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2),class: "total_sale" ,title: '(Unit Price X Quantity)'
              end
            end
          end
        end

      end
      columns do
        column do
          panel "Yearly Stock Report Graph" do
            product = Product.where("created_at >= ?", 1.year.ago)
              column_chart Product.group_by_month_of_year(:created_at, format: "%b").count, download: {filename: "#{Time.now.strftime("%b %d, %Y")}, Yearly Stock Report Graph"}, xtitle: "Months", ytitle: "Added Product", defer: true ,thousands: ",", messages: {empty: "There Is No Data"}
            end
          end
        end
        columns do
          column do
            panel "Recent Added Users" do
              if !(AdminUser.where('created_at >= ?', 1.year.ago).count == 0)
                table_for AdminUser.where('created_at >= ?', 1.year.ago).order("created_at desc").limit(10).each do |_user|
                  column(:full_name)    { |user| link_to(user.full_name, admin_admin_user_path(user)) }
                  column(:role)    { |user| user.role }
                  column(:sign_in_count)    { |user| user.sign_in_count}
                  column("Created At" )   { |user| user.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW USER ADDED TODAY"
                end
                # actions defaults: true do |foo|

                #   link_to "Add New User", new_admin_admin_user_path(foo)

                # end
              end
            end
          end
          column do
            panel "Recent Added Expense" do
              if !(Expense.where('created_at >= ?', 1.year.ago).count == 0)
                table_for Expense.where('created_at >= ?', 1.year.ago).order("created_at desc").limit(10).each do |_expense|
                  column(:expense)    { |expense| link_to(truncate(expense.expense,  :length => 15), admin_expense_path(expense)) }
                  number_column :price, as: :currency, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2
                  column :created_by

                  column("Created At" )   { |expense| expense.created_at.strftime("%b %d, %Y") }
                end
              else
                h3 class: "text-center" do
                  "NO NEW EXPENSE ADDED TODAY"
                end
              end
            end
          end
        end
        columns do
          column do
            panel "Recent Added To Stock" do
              if !(Product.where('created_at >= ?', 1.year.ago).count == 0)
                table_for Product.where('created_at >= ?', 1.year.ago).order("created_at desc").limit(10) do
                  column "Product Image" do |i|
                    image_tag(i.photo.url(:small_thumbnail)) if i.photo.present?
                  end
                  column("Product Name") { |product| link_to(truncate(product.product_name, :length => 20), admin_product_path(product)) }
                  column(:catagory) { |product| product.catagory}
                  column(:quantity) { |product| product.quantity}
                  column(:unit_price)   { |product| number_to_currency(product.unit_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |product| product.created_by }
                  column("Created At" )   { |product| product.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO NEW PRODUCT ADDED TO STOCK TODAY"
                end
              end
            end
          end
          column do
            panel "Recent Sold To Products" do
              if !(Sale.where('created_at >= ?', 1.year.ago).count == 0)
                table_for Sale.where('created_at >= ?', 1.year.ago).order("created_at desc").limit(10) do
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
                  column :type_of_sales
                  column(:total_price)   { |sale| number_to_currency(sale.total_price, unit: "ETB",  format: "%n %u" ,delimiter: "", precision: 2) }
                  column("Created By" )   { |sale| sale.created_by }
                  column("Created At" )   { |sale| sale.created_at.strftime("%b %d, %Y")}
                end
              else
                h3 class: "text-center" do
                  "NO PRODUCT SOLD TODAY"
                end
              end
            end
          end
        end
      end


    end

  end
end
