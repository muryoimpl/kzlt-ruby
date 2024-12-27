class Channel < ApplicationRecord
  has_many :entries, dependent: :destroy

  belongs_to :workspace
end
