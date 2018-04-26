Sequel.migration do
  change do
    alter_table(:resources) do
      add_column :heroku_uuid, :uuid, unique: true, null: false
      drop_column :heroku_id
    end
  end
end
