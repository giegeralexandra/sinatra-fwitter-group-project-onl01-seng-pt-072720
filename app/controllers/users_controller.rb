class UsersController < ApplicationController

    get '/' do 
        erb :'users/homepage'
    end

    get '/signup' do
        if Helpers.logged_in?(session)
            redirect "/tweets"
        end
        erb :'users/signup'
    end
    
    post '/signup' do 
        if params[:username] == "" || params[:password] == "" || params[:email] == ""
            redirect "/signup"
        else
            # binding.pry
            user = User.create(username: params[:username], password: params[:password], email: params[:email])
            session[:user_id] = user.id
            redirect "/tweets"
        end
        #processess the form submission 
        #create user and save it to database
        #needs to log the user in and add the user_id to the sessions hash 
        #make sure to add signup action to home page  
    end

    get '/login' do 
        if Helpers.logged_in?(session)
            redirect "/tweets"
        else 
            erb :'users/login'
        end
        #displays the form to login 
    end

    post '/login' do 
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id]=user.id
            redirect "/tweets"
        else 
            redirect "/login"
        end
        #submits login form and adds user_id to the sessions hash 
    end

    get '/logout' do 
        if Helpers.logged_in?(session)
            session.clear
            redirect "/login"
        else 
            redirect "/login"
        end
        #clears the session hash and redirects to the /login
    end

    get '/users/:slug' do 
        @user = User.find_by_slug(params[:slug])
        @tweets = @user.tweets
        erb :'users/show'
    end




end
