class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  use Rack::Flash
  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  get '/' do
      erb :home
  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb

  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  # Handles the POST request when user submits the Sign Up form. Get user info from the params hash, creates a new user, signs them in, redirects them. 
  post '/registrations' do
      user = User.create(name: params["name"], email: params["email"])
      user.password = params["password"]
      user.save
      session[:user_id] = user.id
      redirect '/registrations/shortner'
  end
  
  # Renders the view page in app/views/sessions/login.erb
  get '/sessions/login' do
      erb :'/sessions/login'
  end

  get '/registrations/shortner' do
    erb :'/registrations/shortner'
  end
  # Handles the POST request when user submites the Log In form. Similar to above, but without the new user creation.
  post '/sessions' do
      user = User.find_by(email: params["email"])
      if user.password == params["password"]
        session[:user_id] = user.id
        redirect '/registrations/shortner'
      else
        redirect '/sessions/login'
      end
  end

  # Logs the user out by clearing the sessions hash. 
  get '/sessions/logout' do
      session.clear
      redirect '/'
  end

######################## home url shortening part only
  post '/urls/home' do
    url = Url.new(url: params["url"])
    if url.valid_url?
      url.save
      flash[:shortened_url] = url.shorten 
    else
      "Invalid Url"
    end
    redirect '/'
  end

############################ shortener page controller
  post '/urls' do
    url =Url.new(url: params["url"])
    if url.valid_url?
      url.user_id = session[:user_id]
      url.save
      flash[:shortened_url] = url.shorten 
    else
      "Invalid Url"
    end
    redirect '/registrations/shortner'
  end

  get '/:base58' do
    shorten_url = Url.find_by_base58(params[:base58])
    if shorten_url
      redirect shorten_url.url
    else
      redirect '/registrations/shortner'
    end
  end

  delete '/urls/:id' do
    url = Url.find_by_id(params[:id])
    if url.user_id == session[:user_id]
      url.destroy
    end
    redirect '/registrations/shortner'
  end


  helpers do 

    def current_user
      @current_user ||= User.find(session[:user_id])
    end
  end

end
