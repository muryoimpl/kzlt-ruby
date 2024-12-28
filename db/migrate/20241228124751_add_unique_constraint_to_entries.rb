# frozen_string_literal: true

class AddUniqueConstraintToEntries < ActiveRecord::Migration[8.0]
  def change
    add_index(:entries, %i[channel_id user_id title], unique: true)
  end
end
