# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :slack_user_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
