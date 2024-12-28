# frozen_string_literal: true

class User < ApplicationRecord
  has_many :entries, dependent: :destroy

  validates :slack_user_id, presence: true, uniqueness: true
  validates :name, presence: true
end
