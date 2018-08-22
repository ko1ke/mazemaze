class RenameTypeColumnToParsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :parsers, :type, :input_type

  end
end
