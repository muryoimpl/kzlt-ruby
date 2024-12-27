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
end
