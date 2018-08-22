class AddColumnToResult < ActiveRecord::Migration[5.1]
  def change
    add_column :results, :parser_id, :integer
  end
end
