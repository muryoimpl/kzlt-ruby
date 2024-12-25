class Workspace < ApplicationRecord
  has_many :channels, dependent: :destroy
end
