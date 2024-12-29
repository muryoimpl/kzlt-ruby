class AddTeamIdToWorskpaces < ActiveRecord::Migration[8.0]
  def change
    add_column(:workspaces, :slack_team_id, :string, null: false)
    add_index(:workspaces, :slack_team_id, unique: true)

    remove_index(:workspaces, :token)
    remove_column(:workspaces, :token, :string, null: false)
  end
end
