require "sinatra/activerecord"
require 'sinatra'

enable :sessions

if ENV['RACK_ENV']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  else
	set :database, {adapter: "sqlite3", database: "database.sqlite3"}
  end

class User < ActiveRecord::Base
	has_many :posts
	has_many :tags
	has_many :favorites
end

class Post < ActiveRecord::Base
	 belongs_to :user
	 belongs_to :tag
end

class Favorite < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
end

class PostTag < ActiveRecord::Base
	belongs_to :tag
	belongs_to :post
	has_many :tags, through: :post_tags
end


class Tag < ActiveRecord::Base

end



get '/' do 
    p session
	erb :index	
end

get '/post' do 
	erb :post, :layout => :layout_profile
end

get '/index' do 
	erb :index	
end



get '/home' do 
	if !session[:id].nil?
			erb :home, :layout => :layout_loggedin 
		else
			erb :login
		end
end



get '/signup' do
	erb :signup
end

get '/invalid' do
	erb :invalid
  end

  post '/signup' do
	p params
	user = User.new(
	  email: params['email'],first_name: params['first_name'],last_name: params['last_name'],username: params['username'],password: params['password'],birthday: params['birthday'])
  user.save
  if user != nil
	  email = params['email']
	  input_password = params['password']
	  user = User.find_by(email: email) 
		user.password == input_password
		session[:id] = user
		erb :home, :layout => :layout_loggedin 
	else
	  p 'error in signup'
	  redirect '/signup'
	end
end



get '/profile' do
	if !session[:id].nil?

	  erb :profile, :layout => :layout_loggedin
	else
	  erb :login
	end
  end

get '/notification' do
	if !session[:id].nil?

	  erb :notification, :layout => :layout_loggedin
	else
	  erb :login
	end
  end

get '/login' do
	erb :login
end


post '/login' do
	email = params['email']
	input_password = params['password']
  
	user = User.find_by(email: email)
	unless user == nil
	  if user.password == input_password
		session[:id] = user
		 erb :home, :layout => :layout_loggedin
	  else
		redirect '/invalid'
	  end
	end
  end



get '/logout' do
	session.clear
	redirect :'/login'
end


get '/new' do 
	if !session[:id].nil?

		erb :new, :layout => :layout_profile
	else
	  erb :login
	end
end



 post '/new' do 
	posting = Post.create(
		title: params[:title],
		body: params[:body],
		date: params[:date],
		user_id: session[:id].id
	  )
	
	  if !posting.nil?
		posting.save
	  else
		p 'try again'
	  end
	
	  redirect '/new'
end



 get '/myblog' do
	 @post = Post.where(user_id: session[:id])
	 if !session[:id].nil?

		erb :myblog, :layout => :layout_loggedin
	else
	  erb :login
	end
 	
 end


get '/social' do
	@users = User.all
	if !session[:id].nil?

		erb :social, :layout => :layout_loggedin
	else
	  erb :login
	end

end


get '/profileblog' do
	@specific_profile = User.find(params[:id])
	if !session[:id].nil?

		erb :profileblog, :layout => :layout_profile
	else
	  erb :login
	end
	
end

get '/profileblog/:id' do
	@specific_profile = User.find(params[:id])
	@post = Post.where(user_id: @specific_profile.id)
	erb :profileblog, :layout => :layout_profile
end

get '/myblog/:id/edit' do 
    @specific_post = Post.find(params[:id])
    erb :edit, :layout => :layout_profile
end


#Edit post from /id/edit route (U)
put '/myblog/:id' do
    @specific_post = Post.find(params[:id])
    @specific_post.update(title:params[:title],body:params[:body],date: params[:date],user_id: session[:id])
    redirect '/myblog'
end

 # Show individual post
get '/myblog/:id' do
	@post = Post.find(params[:id])
	erb :post, :layout => :layout_loggedin
end 

get "/feed" do

		@users = User.all.reverse
		@posts = Post.all.reverse
		if !session[:id].nil?
		erb :feed, :layout => :layout_loggedin
		
else 
		redirect '/login'
end
 
end


post '/delete_post' do
  @specific_post = Post.destroy(params[:id])
  redirect '/myblog'
end

post '/delete' do
	User.find(session[:id].id).destroy 
	p "USER #{session[:id].first_name} DELETED"
	session[:id] = nil
	redirect '/login'
  end

