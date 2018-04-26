Sequel.migration do
  change do
    alter_table(:resources) do
      add_column :deleted_at, Time
    end
  end
end
