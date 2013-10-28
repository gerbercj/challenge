require 'pry-debugger'
require 'sinatra'
require 'json'
require 'uri'

# http://localhost:4567/?data=%7B%22x%22%3A0%2C%22y%22%3A-18%2C%22hp%22%3A10%2C%22N%22%3A%22TEAM%22%2C%22E%22%3A%22WALL%22%2C%22S%22%3A%22OOB%22%2C%22W%22%3A%22EMPTY%22%7D

TEAM=10

get '/' do
  move(params[:data])
end

def move(json)
  # Parse the input
  vals=JSON.parse(json)

  # Create convenient variables
  vals.keys.each { |key| send(:instance_variable_set, "@#{key}", vals[key]) }

  # Prioritize the directions
  if @x.abs > @y.abs
    if @x > 0
      list = %w{W N E S}
    else
      list = %w{E N W S}
    end
  else
    if @y > 0
      list = %w{S E N W}
    else
      list = %w{N E S W}
    end
  end

  # Alternate direction on less preferred axis
  if 0 == rand(2)
    temp = list[1]
    list[1] = list[3]
    list[3] = temp
  end
  
  # Score the directions
  result = list.map do |item|
    case vals[item]
    when 'OOB','WALL'
      [ item, 0 ]
    when 'EMPTY'
      [ item, 2 ]
    when 'TEAM'
      [ item, (@hp > 3) ? 2 : 1 ]
    end
  end

  # Sort directions by score
  next_command = result.sort_by! { |item| -item[1] }.first[0]

  # Print debugging information
  p vals, list, result, next_command

  # Return best move
  return { 'team'=>TEAM, 'nextCommand' => next_command }.to_json
end

