module Yesterday
end

ActiveSupport.on_load(:active_record) do
  include Yesterday::Model
end
