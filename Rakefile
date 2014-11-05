require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'gamez4dayz'
  })

require 'sinatra/activerecord/rake'

namespace :db do
  desc 'create gamez4dayz database'
  task :create_db do
    conn = PG::Connection.open()
    conn.exec("CREATE DATABASE gamez4dayz;")
    conn.close
  end

  desc 'drop gamez4dayz database'
  task :drop_db do
    conn = PG::Connection.open()
    conn.exec("DROP DATABASE gamez4dayz;")
    conn.close
  end

end