Sequel.migration do
  change do
    alter_table(:resources) do
      add_column :key_id, :integer, null: false
      add_column :oauth_grant_encrypted, :bytea, null: false
      add_column :oauth_token_data_encrypted, :bytea
      drop_column :oauth_grant
      drop_column :oauth_token_data
    end
  end
end
