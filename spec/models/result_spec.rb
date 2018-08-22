# == Schema Information
#
# Table name: results
#
#  id                  :integer          not null, primary key
#  surface             :string
#  part_of_speech      :string
#  part_division1      :string
#  part_division2      :string
#  part_division3      :string
#  type_of_conjugation :string
#  form_of_conjugation :string
#  model               :string
#  yomi                :string
#  pronunciation       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  parser_id           :integer
#

require 'rails_helper'

RSpec.describe Result, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
