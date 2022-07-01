require 'json'
class Handler

  def initialize
    database_file = File.expand_path('common/database.json', File.dirname(__FILE__))
    self.db = JSON.parse(database_file, object_class: OpenStruct)
  end


  def run(body, headers)
    puts("Body: #{body}")
    payload = JSON.parse(body.string)
    puts(payload.inspect)
    
    parent = payload.fetch("parent", {})
    parent_id = parent.fetch("id", nil)
    
    args = payload.fetch("args", {})
    id = args.fetch("id", nil)

    puts("parent_id: #{parent_id}, id: #{id}")

    client_studies = self.db.clientStudies
    
    data = nil
    if id
      studies = client_studies.map(&:values).flatten
      data = studies.find {|e| e == id}
    elsif parent_id
      data = client_studies.fetch(parent_id)
    end

    STDOUT.flush
    return JSON.generate(data), {"content-type" => "application/json"}, 200
  end
end
