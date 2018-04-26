Sequel.migration do
  change do
    alter_table(:resources) do
      add_column :oauth_token_data, :json
      add_column :oauth_grant, :json, null: false
    end
  end
end
