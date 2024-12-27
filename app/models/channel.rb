# frozen_string_literal: true

class Channel < ApplicationRecord
  has_many :entries, dependent: :destroy

  belongs_to :workspace
end
