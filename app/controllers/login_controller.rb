class LoginController < ApplicationController
  layout 'login'
  	def index
              # render :text =>"hi"
  	     redirect_to :action => "signin"	
  	end
  	
    def signup
    case request.method 
    when :post 
      @user = User.new(params[:user]) 
      @user.pw = params[:user][:password]

  	#stylesheet setting setup
      unless Stylesheet.find(:first).nil? 
	      @user.stylesheet_id = Stylesheet.find(:first).id;
	  else
			
	  	@stylesheet = Stylesheet.new
	    @stylesheet.name = "advanced3.css"
	    @filefolder = "#{RAILS_ROOT}/public/stylesheets"
	    @stylesheet.css =""
	    File.open("#{@filefolder}/#{@stylesheet.name}", "rb") do |file|
			file.each do |line|
				@stylesheet.css.concat(line)
			end
		end
	  	
	  	if @stylesheet.save
			flash[:notice] = 'Stylesheet was successfully created.'
			@user.stylesheet_id = Stylesheet.find(:first).id;
	    end
      end

      if @user.save 
	 		
	 		#### Create HOME Folder
	 		@filefolder = "#{RAILS_ROOT}/public/Users/#{@user.login}"
	    	# Check to see if it exists
		    unless File.exists?(@filefolder)
		      Dir.mkdir "#{@filefolder}"
		    end
	
			####Create and save content category
		    @category = Category.new
		    @category.title = "home"
		    @category.publish = 1
		    @category.user_id = @user.id
		    @category.save	
		    
		    #### Create index page
		    @webpage = Webpage.new
		    @filename = "index.rhtml"
		    @webpage.description = "Home"
		    @webpage.file_name = @filename
		    @webpage.publish = 1
	    	@webpage.content_type = "text/rhtml"
	  		@webpage.url = "/Users/#{@user.login}/#{@filename}"
		    
		  	@text = "<h2> Welcome to #{@user.login} webiste! </h2><br/><br/> This is a homepage."
		    @webpage.text = @text
	
		  	if @webpage.save
			    File.open("#{@filefolder}/#{@filename}", "wb") do |outs| 
			    	outs.puts  " #{@text} "
		    	end
		    end
		    	SharedMailer.deliver_new_account :user => @user
					flash[:notice] = 'Create user account successfully.'
	        redirect_to :controller => 'login', :action => 'signin'
	      end 
	  
    	

    end 
  end
  
  def test
     
     #render :text => "hellooooo"
     render :text => "#{User.authenticate(params[:user][:login], params[:user][:password]).to_s}"

  end
  def login
    if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])    
      redirect_to :controller => 'cms'
    else 
    	flash[:notice] = 'Login name and password is incorrect, Please try again.'
      redirect_to :controller => 'login', :action => 'signin'
    end 
  end
  
  def logout 
    reset_session 
    redirect_to :controller => 'login' , :action => 'signin'
  end
end
