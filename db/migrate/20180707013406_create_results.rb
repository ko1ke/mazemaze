class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.string :surface
      t.string :part_of_speech
      t.string :part_division1
      t.string :part_division2
      t.string :part_division3
      t.string :type_of_conjugation
      t.string :form_of_conjugation
      t.string :model
      t.string :yomi
      t.string :pronunciation

      t.timestamps
    end
  end
end
