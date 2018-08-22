class CreateParsers < ActiveRecord::Migration[5.1]
  def change
    create_table :parsers do |t|
      t.text :txt

      t.timestamps
    end
  end
end
