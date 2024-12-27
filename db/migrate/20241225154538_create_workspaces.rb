# frozen_string_literal: true

class CreateWorkspaces < ActiveRecord::Migration[8.0]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.string :token, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
