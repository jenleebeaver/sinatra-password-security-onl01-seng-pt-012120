require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index #signup or login page
	end

	get "/signup" do #form to create a new user
		erb :signup
	end

	post "/signup" do
		  user = User.new(:username => params[:username], :password => params[:password])
			#creating instance of our user
			if user.save
    redirect "/login"
  else
    redirect "/failure"
  end
	end

	get "/login" do #form for logging in
		erb :login
	end

  post "/login" do
    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password]) #asking us if we have a user and if the user is authenticated
      session[:user_id] = user.id
      redirect "/success"
    else
      redirect "/failure"
    end
  end

	get "/success" do #displayed once user succesfully logs in
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do #login error
		erb :failure
	end

	get "/logout" do #clears session and redirects to home page or login page
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!session[user_id]
		end

		def current_user
			User.find(session[user_id])
		end
	end

end
