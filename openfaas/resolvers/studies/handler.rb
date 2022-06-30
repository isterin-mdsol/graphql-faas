require 'json'
class Handler
  CLIENT_STUDIES = {
    "1" => [
      {"id" => "1", "name" => "Study 1"},
      {"id" => "2", "name" => "Study 2"},
    ],
    "2" => [
      {"id" => "3", "name" => "Study 3"},
      {"id" => "4", "name" => "Study 4"},
    ],
  }
  
  def run(body, headers)
    puts("Body: #{body}")
    body_json = JSON.parse(body.string)
    puts(body_json.inspect)
    
    parent_id = body_json["parent_id"]
    id = body_json["id"]
    puts("parent_id: #{parent_id}, id: #{id}")

    data = CLIENT_STUDIES[parent_id]
    puts("data: #{data.inspect}")
    if id
      data = data[id]
    end

    return_body = JSON.generate(data)

    STDOUT.flush
    return return_body, {"content-type" => "application/json"}, 200
  end
end
