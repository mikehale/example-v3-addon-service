require 'que'

Sequel.migration do
  up do
    Que.connection = self
    Que.migrate!
  end

  down do
    Que.connection = self
    Que.migrate!(version: 0)
  end
end
