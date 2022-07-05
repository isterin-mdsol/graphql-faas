require 'json'
class Handler

  def initialize
    database = File.read(File.expand_path('common/database.json', File.dirname(__FILE__)))
    @db = JSON.parse(database)
  end


  def run(body, headers)
    puts("Body: #{body}")
    payload = JSON.parse(body.string)
    puts(payload.inspect)
    
    parent_id = payload.dig("parent", "id")    
    id = payload.dig("args", "id")

    puts("parent_id: #{parent_id}, id: #{id}")

    client_studies = @db['clientStudies']
    
    data = nil
    if id
      studies = client_studies.map(&:values).flatten
      data = studies.find {|e| e == id}
    elsif parent_id
      data = client_studies[parent_id]
    end

    puts("RETURNING DATA: #{data.inspect}")

    STDOUT.flush
    return JSON.generate(data), {"content-type" => "application/json"}, 200
  end
end
