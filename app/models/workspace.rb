# frozen_string_literal: true

class Workspace < ApplicationRecord
  has_many :channels, dependent: :destroy

  validates :name, presence: true
  validates :slack_team_id, presence: true, uniqueness: true
end
