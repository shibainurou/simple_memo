# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'erubis'
require 'sinatra/reloader'

set :erb, escape_html: true

CONTENT_FILE_PATH = 'resource/todo.json'
ID_NUMBERING_FILE_PATH = 'resource/id_numbering'

set :views, (proc { File.join(Sinatra::Application.root, 'app', 'views') })

enable :sessions
enable :method_override

Memo = Struct.new(:id, :title, :content)

before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  erb :index
end

get '/add' do
  erb :new
end

post '/save' do
  data = JSON.parse(read_memos)

  new_id = numbering_id
  new_data = {
    'id' => new_id,
    'title' => params[:title],
    'content' => params[:content]
  }

  data << new_data
  write_memos(data)

  redirect '/'
end

patch '/update' do
  data = JSON.parse(read_memos)
  update_data = data.find { |x| x['id'].to_i == session[:id].to_i }

  unless update_data.nil?
    puts update_data
    update_data[:title] = params[:title]
    update_data[:content] = params[:content]

    write_memos(data)
  end

  redirect '/'
end

delete '/delete' do
  data = JSON.parse(read_memos)
  data.delete_if { |x| x['id'].to_i == session[:id].to_i }

  write_memos(data)
  redirect '/'
end

get '/detail' do
  @target = { id: params[:id] }
  session[:id] = params[:id]
  erb :detail
end

get '/api/memos' do
  read_memos.to_json
end

get '/api/memos/:id' do
  file = read_memos
  memo_data = JSON.parse(file)
  target = memo_data.find { |x| x['id'].to_i == params[:id].to_i }
  target.to_json
end

def read_memos
  File.read(CONTENT_FILE_PATH)
end

def numbering_id
  last_id_number = File.read(ID_NUMBERING_FILE_PATH)
  new_id_number = last_id_number.to_i + 1

  File.open(ID_NUMBERING_FILE_PATH, 'w') do |numbering_file|
    numbering_file.puts new_id_number.to_s
  end

  new_id_number
end

def write_memos(data)
  File.open(CONTENT_FILE_PATH, 'w') do |content_file|
    content_file.puts data.to_json
  end
end
