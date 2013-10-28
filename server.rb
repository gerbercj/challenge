require 'sinatra'
require 'json'

get '/' do
  { teamNumber: 10, direction: 'N' }.to_json
end
