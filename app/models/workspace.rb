# frozen_string_literal: true

class Workspace < ApplicationRecord
  has_many :channels, dependent: :destroy
end
