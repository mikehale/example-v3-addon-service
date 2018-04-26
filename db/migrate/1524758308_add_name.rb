Sequel.migration do
  change do
    alter_table(:resources) do
      add_column :name, :text, null: false
    end
  end
end
