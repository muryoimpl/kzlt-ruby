# frozen_string_literal: true

class AddKanazawarbToWorkspaces < ActiveRecord::Migration[8.0]
  def up
    Workspace.create!(name: 'Kanazawa.rb', slack_team_id: 'T02A6KL7S')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
