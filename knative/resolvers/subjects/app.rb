require 'sinatra'
require 'json'

set :bind, '0.0.0.0'

database = File.read(File.expand_path('database.json', File.dirname(__FILE__)))
db = JSON.parse(database)

post '/' do
  payload = JSON.parse(request.body.read)
  puts(payload.inspect)
  
  parent_id = payload.dig("parent", "id")    
  id = payload.dig("args", "id")

  puts("parent_id: #{parent_id}, id: #{id}")
  study_subjects = db['studySubjects']

  client_studies = db['clientStudies']
    
  data = nil
  if id
    subjects = study_subjects.map(&:values).flatten
    data = subjects.find {|e| e == id}
  elsif parent_id
    data = study_subjects[parent_id]
  end
    
  data.to_json
end
