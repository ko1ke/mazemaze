class AddColumnToParser < ActiveRecord::Migration[5.1]
  def change
    add_column :parsers, :type, :string
  end
end
