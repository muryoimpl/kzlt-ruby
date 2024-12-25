class CreateChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channels do |t|
      t.string :name, null: false
      t.string :channel_id, null: false, index: { unique: true }
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
