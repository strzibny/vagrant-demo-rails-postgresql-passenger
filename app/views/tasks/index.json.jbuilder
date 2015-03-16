json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :note, :completed
  json.url task_url(task, format: :json)
end
