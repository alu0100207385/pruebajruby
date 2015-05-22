# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'data_mapper'

class MyApp < Sinatra::Base

	configure :development do
   		DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/people.db" )
   	end

   	configure :production do
   		#DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
   		#DataMapper.setup(:default, ENV['OPENSHIFT_POSTGRESQL_DB_URL2'] || ENV['HEROKU_POSTGRESQL_ONYX_URL'])
   		DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_ONYX_URL'])
   	end

	DataMapper::Logger.new($stdout, :debug)
	DataMapper::Model.raise_on_save_failure = true

	require_relative '../models/model'

	DataMapper.finalize
	DataMapper.auto_upgrade!


	configure do
		set :root, File.dirname(__FILE__)
		set :views, Proc.new { File.join(root, "../views") }
		set :erb, :layout => :'layouts/layout'
	end

	get '/' do
		@list = User.all
		erb :index
	end

	post '/' do
		@list = User.first_or_create(:name => params[:input1], :rol => params[:input2])
		redirect '/'
	end

	post '/delete' do
		User.destroy
		redirect '/'
	end

	# start the server if ruby file executed directly
  	run! if app_file == $0
end
