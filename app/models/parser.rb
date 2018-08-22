# frozen_string_literal: true
# == Schema Information
#
# Table name: parsers
#
#  id         :integer          not null, primary key
#  txt        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  input_type :string
#  user_id    :integer
#

class Parser < ApplicationRecord
  # enum input_type: {
  #     "plain" => 0,
  #     "markup" => 1,
  #     "url" => 2
  # }
  belongs_to :user
  has_many :results, dependent: :destroy
  validates :input_type, presence: true


end
