class AddUserRefToParsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :parsers, :user, foreign_key: true
  end
end
