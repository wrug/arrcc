ActiveRecord::Schema.define do
  def except(adapter_names_to_exclude)
    unless [adapter_names_to_exclude].flatten.include?(adapter_name)
      yield
    end
  end

  #put adapter specific setup here
  case adapter_name
    # For Firebird, set the sequence values 10000 when create_table is called;
    # this prevents primary key collisions between "normally" created records
    # and fixture-based (YAML) records.
  when "Firebird"
    def create_table(*args, &block)
      ActiveRecord::Base.connection.create_table(*args, &block)
      ActiveRecord::Base.connection.execute "SET GENERATOR #{args.first}_seq TO 10000"
    end
  end

  create_table :cars, :force => true do |t|
    t.string  :name
  end

  create_table :categories, :force => true do |t|
    t.string :name, :null => false
    t.string :type
  end

  create_table :categorizations, :force => true do |t|
    t.column :category_id, :integer
    t.column :post_id, :integer
    t.column :author_id, :integer
  end

  create_table :topics, :force => true do |t|
    t.string   :title
    t.string   :author_name
    t.string   :author_email_address
    t.datetime :written_on
    t.time     :bonus_time
    t.date     :last_read
    t.text     :content
    t.boolean  :approved, :default => true
    t.integer  :replies_count, :default => 0
    t.integer  :parent_id
    t.string   :parent_title
    t.string   :type
    t.string   :group
  end
end