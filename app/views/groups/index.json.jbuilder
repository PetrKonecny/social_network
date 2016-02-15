json.array!(@groups) do |group|
  json.extract! group, :id, :user_id, :name, :type_group
  json.url group_url(group, format: :json)
end
