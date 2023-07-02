# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'erubis'
require 'sinatra/reloader'
require 'pg'

set :erb, escape_html: true
set :views, (proc { File.join(Sinatra::Application.root, 'app', 'views') })
enable :method_override

ID_NUMBERING_FILE_PATH = 'resource/id_numbering.txt'
@db_conn = nil

before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  erb :memos
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  new_id = number_id
  new_data = {
    'id' => new_id,
    'title' => params[:title],
    'content' => params[:content]
  }

  insert_memo(new_data)

  redirect '/memos'
end

patch '/memos/:id' do
  update_data = read_memos.find { |x| x['id'].to_i == params[:id].to_i }
  unless update_data.nil?
    update_data['title'] = params[:title]
    update_data['content'] = params[:content]

    update_memo(update_data)
  end

  redirect '/memos'
end

delete '/memos/:id' do
  delete_memo = read_memos.find { |x| x['id'].to_i == params[:id].to_i }

  delete_memo(delete_memo)
  redirect '/memos'
end

get '/memos/:id' do
  session[:id] = params[:id]
  erb :detail
end

get '/api/memos' do
  read_memos.to_json
end

get '/api/memos/:id' do
  memo_data = read_memos
  target = memo_data.find { |x| x['id'].to_i == params[:id].to_i }
  target.to_json
end

def read_memos
  results = []

  db_connection.exec('SELECT * FROM memos ORDER BY id').each do |row|
    results << {
      'id' => row['id'].to_i,
      'title' => row['title'],
      'content' => row['description']
    }
  end

  results
end

def number_id
  last_id_number = 0
  last_id_number = File.read(ID_NUMBERING_FILE_PATH) if File.exist?(ID_NUMBERING_FILE_PATH)
  new_id_number = last_id_number.to_i + 1

  File.open(ID_NUMBERING_FILE_PATH, 'w') do |numbering_file|
    numbering_file.puts new_id_number.to_s
  end

  new_id_number
end

def db_connection
  @db_conn = connect_db if @db_conn.nil?
  @db_conn
end

def connect_db
  PG::Connection.open(dbname: 'memo_app')
end

def insert_memo(data)
  db_connection.exec('INSERT INTO memos (id, title, description) VALUES ($1, $2, $3)', [data['id'], data['title'], data['content']])
end

def update_memo(data)
  db_connection.exec('UPDATE memos SET title = $1, description = $2 WHERE id = $3', [data['title'], data['content'], data['id']])
end

def delete_memo(data)
  db_connection.exec('DELETE FROM memos WHERE id = $1', [data['id']])
end
