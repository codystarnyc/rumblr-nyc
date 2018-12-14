require "sinatra/activerecord"
require 'sinatra'

enable :sessions

if ENV['RACK_ENV']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  else
	set :database, {adapter: "sqlite3", database: "database.sqlite3"}
  end

class User < ActiveRecord::Base

end

class Post < ActiveRecord::Base

end

class Favorite < ActiveRecord::Base
	
end

class PostTag < ActiveRecord::Base

end

class Tag < ActiveRecord::Base

end



get '/' do 
    p session
	erb :index	
end

get '/post' do 
	erb :post, :layout => :layout_loggedin	
end

get '/index' do 
	erb :index	
end



get '/home' do 
	@user = User.find(session[:id])
	erb :home,:layout => :layout_loggedin
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
	  email: params['email'],
	  first_name: params['first_name'],
	  last_name: params['last_name'],
	  username: params['username'],
	  password: params['password'],
	  birthday: params['birthday']
	)
  
	user.save
  
	if user != nil
	  # this signs them in
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
# post '/signup' do
# 	@user = User.create(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], username: params[:username], password: params[:password], birthday: params[:birthday])
#     session[:id]= @user.id
#     @user.save
	# erb :home, :layout => :layout_loggedin 
# end


get '/profile' do
	if !session[:id].nil?
	  erb :profile, :layout => :layout_loggedin 
	else
	  erb :login
	end
  end
	# @user = User.find(session[:id])
# 	erb :admin, :layout => :layout_loggedin
# end


# get '/admin/:id' do 
# 	@user = User.find(session[:id])
# 	erb :admin, :layout => :layout_loggedin
# end


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


# Logout
get '/logout' do
	session.clear
	redirect :'/login'
end

#New get and post route
get '/new' do 
	erb :new, :layout => :layout_loggedin
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



#  	@post = Post.create(title:params[:title],body:params[:body],date: params[:date],user_id: session[:id])
#  	redirect :'/home', :layout => :layout_loggedin	
#  end


 get '/myblog' do
 	@post = Post.where(user_id: session[:id])
 	erb :myblog, :layout => :layout_loggedin
 end

#  get '/home' do
#  	@user = User.find(session[:id])
#  	@post = Post.where(user_id: session[:id])
#  	erb :home, :layout => :layout_loggedin 
#  end


# Show all users in "Social" page

get '/social' do
	@users = User.all
	erb :social, :layout => :layout_loggedin 
end


# Setup other user's profile and blog one page
get '/profile' do
	@specific_profile = User.find(params[:id])
	erb :profile, :layout => :layout_loggedin
end

get '/profile/:id' do
	@specific_profile = User.find(params[:id])
	@post = Post.where(user_id: @specific_profile.id)
	erb :profile, :layout => :layout_loggedin
end


# Render form for editing a new post (U)
get '/myblog/:id/edit' do 
    @specific_post = Post.find(params[:id])
    erb :edit, :layout => :layout_loggedin
end


#Edit post from /id/edit route (U)
put '/myblog/:id' do
    @specific_post = Post.find(params[:id])
    @specific_post.update(title:params[:title],body:params[:body],date: params[:date],user_id: session[:id])
    redirect :'/myblog'
end

# Show individual post
get '/myblog/:id' do
	@post = Post.find(params[:id])
	erb :post, :layout => :layout_loggedin
end
  
# Delete Attendee (D)
delete '/admin' do
	@current_user = session[:id]
    User.destroy(@current_user)
    session.clear
    redirect :'/signup'
end

#Delete Post

delete '/myblog/:id' do
  @specific_post = Post.destroy(params[:id])
  redirect '/myblog'
end

