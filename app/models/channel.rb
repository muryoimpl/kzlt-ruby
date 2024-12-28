# frozen_string_literal: true

class Channel < ApplicationRecord
  has_many :entries, dependent: :destroy

  belongs_to :workspace

  validates :name, presence: true
  validates :slack_channel_id, presence: true, uniqueness: true
  validates :workspace_id, presence: true
end
