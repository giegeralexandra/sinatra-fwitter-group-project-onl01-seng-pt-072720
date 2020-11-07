class TweetsController < ApplicationController

    get '/tweets' do 
        if Helpers.logged_in?(session)
            @user = User.find(session[:user_id])
            @tweets = Tweet.all
            erb :'tweets/index'
        else 
            redirect "/login"
        end
        #displays all tweets for logged in users 
        #if user is not logeed in, redirect to /login
    end

    get '/tweets/new' do 
        if Helpers.logged_in?(session)
            erb :'tweets/new'
        else 
            redirect "/login"
        end
        #needs to be a logged in user and has to be from their self 
        #loads create tweet form

    end

    post '/tweets' do 
        if params[:content].empty?
            redirect "/tweets/new"
        elsif Helpers.logged_in?(session)
            tweet = Tweet.create(content: params[:content], user_id: session[:user_id])
            redirect "/tweets/#{tweet.id}"
        else 
            redirect "/login"
        end
        #tweet needs to be created and saved to database
    end

    get '/tweets/:id' do 
        @tweet = Tweet.all.find(params[:id])
        if Helpers.logged_in?(session)
            erb :'tweets/show'
        else 
            redirect "/login"
        end
    end

    get '/tweets/:id/edit' do 
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @tweet = Tweet.find(params[:id])
            if @tweet.user_id != session[:user_id]
                redirect "/tweets/#{params[:id]}"
            else
                erb :'tweets/edit'
            end
        end
        #has to be logged in and editing their own tweet
        #loads edit form 
        #cannot be blank content 
    end

    patch '/tweets/:id' do 
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @tweet = Tweet.find(params[:id])
            if @tweet.user_id != session[:user_id]
                redirect "/tweets/#{@tweet.id}"
            elsif params[:content] == ""
                redirect "/tweets/#{@tweet.id}/edit"
            else
                @tweet.update(content: params[:content])
                redirect "/tweets/#{@tweet.id}/edit"
            end
        end
    end

    delete '/tweets/:id' do 
        @tweet = Tweet.find(params[:id])
        if @tweet.user_id == session[:user_id]
            @tweet.destroy 
            redirect "/tweets"
        else 
            redirect "/tweets/#{@tweet.id}"
        end
        #has to be logged in and deleting their own tweet 
    #form should be found on show page 
    #no input fields just a submit button
    end



end
