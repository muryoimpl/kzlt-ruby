# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :channel
  belongs_to :user

  enum :status, {
    unordered: 0,
    ordered: 1,
    delimited: 2,
    removed: 3
  }, validate: true

  validates :title, presence: true, uniqueness: { scope: %i[channel_id user_id] }
  validates :channel_id, presence: true
  validates :user_id, presence: true
end
