# frozen_string_literal: true

class Workspace < ApplicationRecord
  has_many :channels, dependent: :destroy

  validates :name, presence: true
  validates :token, presence: true, uniqueness: true
end
