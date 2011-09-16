class AdminController < ApplicationController
  def index
  	render :action => 'setting'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }



  ##########	show all admins ##############################
  def list
    @admins = Admin.find(:all)
  end

  ##########	show one admin, get id from post	 ##############################
  def show
    @admin = Admin.find(params[:id])
  end

  ##########	new admin for new object , but not save it yet   ##############################
  def new
    @admin = Admin.new
  end

  ##########	get new admin data from FORM, and save it	 ##############################
  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      flash[:notice] = 'Admin was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  ##########	edit a selected admins, links from List of admin table   ##############################
  def edit
    @admin = Admin.find(params[:id])
  end

  ##########	after edit FORM, then when user clicks Edit button, it come here and update ####
    def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
      flash[:notice] = 'Admin was successfully updated.'
      redirect_to :action => 'show', :id => @admin
    else
      render :action => 'edit'
    end
  end

  ##########	destroy selected admin ##############################
  def destroy
    Admin.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  ##########	make a session id for admins ##############################
  def login
    if session[:admin] = Admin.authenticate(params[:admin][:login], params[:admin][:password]) 
      redirect_to :controller => 'admin', :action => 'setting'
    else 
    	flash[:notice] = 'Login name and password is incorrect, Please try again.'
      redirect_to :controller => 'admin', :action => 'signin'
    end 
  end
  
  ##########	end the session when log out  ##############################  
  def logout 
    reset_session 
    redirect_to :controller => 'admin' , :action => 'signin'
  end


######################## manage user #####################################

  def user_list
    @users = User.find(:all)
  end

  def user_show
    @user = User.find(params[:id])
  end

  def user_destroy
  	@user = User.find(params[:id])
    for category in @user.categories
    	for webpage in category.webpages 
    		webpage.destroy
    	end		
    	category.destroy
	end
	
	for photo in @user.photos
		photo.destroy
	end	
	
	for song in @user.songs
		song.destroy
	end	

	for video in @user.videos
		video.destroy
	end	

	for fileclassified in @user.fileclassifieds
		fileclassified.destroy
	end	

	for header in @user.headers
		header.destroy
	end	

	for footer in @user.footers
		footer.destroy
	end	

    for blog in @user.blogs
    	for comment in blog.comments 
    		comment.destroy
    	end		
    	blog.destroy
	end

	for contact in @user.contacts
		contact.destroy
	end	

    tree("#{RAILS_ROOT}/public/Users/#{@user.login}")

 	@user.destroy
    redirect_to :action => 'user_list'
  end
  

  def tree(directory)  
  	Dir.foreach(directory) do |entry|    
  		next if entry =~ /^\.\.?$/     
  		path = directory + "/" + entry    
  		if FileTest.directory?(path)      
  			tree(path)       		#  /. and /..
  		else      
  			File.delete(path)    
  		end  
  	end  
  	Dir.delete(directory)
  end
  	

######################## manage stylesheet #####################################
  def stylesheet_list
    @stylesheets = Stylesheet.find(:all)
  end

  def stylesheet_show
    @stylesheet = Stylesheet.find(params[:id])
  end

  def stylesheet_new
    @stylesheet = Stylesheet.new
  end

  def stylesheet_create
    @stylesheet = Stylesheet.new(params[:stylesheet])
    if @stylesheet.save
      flash[:notice] = 'Stylesheet was successfully created.'
      redirect_to :action => 'stylesheet_list'
    else
      render :action => 'stylesheet_new'
    end
  end

  def stylesheet_edit
    @stylesheet = Stylesheet.find(params[:id])
  end

  def stylesheet_update
    @stylesheet = Stylesheet.find(params[:id])
    if @stylesheet.update_attributes(params[:stylesheet])
      flash[:notice] = 'Stylesheet was successfully updated.'
      redirect_to :action => 'stylesheet_show', :id => @stylesheet
    else
      render :action => 'stylesheet_edit'
    end
  end

  def stylesheet_destroy
    Stylesheet.find(params[:id]).destroy
    redirect_to :action => 'stylesheet_list'
  end

  def stylesheet_upload
    @stylesheet = Stylesheet.new
  end

  def stylesheet_createupload
  	unless params[:stylesheet][:name].size > 0
      flash[:notice] = 'Failed uploading. You should select some files to upload.'
      redirect_to :action => 'stylesheet_upload'
  	else
	    @stylesheet = Stylesheet.new(params[:stylesheet])
	    @stylesheet.css = @params['stylesheet']['name'].read
	
	  	@stylesheet.name = params[:stylesheet][:name].original_filename
	  	#@stylesheet.content_type = params[:stylesheet][:name].content_type
	  	#Directory path
		@filefolder = "#{RAILS_ROOT}/public/stylesheets"
	
	  	if @stylesheet.save
		    File.open("#{@filefolder}/#{@stylesheet.name}", "wb") do |f| 
		      f.write(@params['stylesheet']['name'].read)
	    	end
		      flash[:notice] = 'Stylesheet was successfully created.'
		      redirect_to :action => 'stylesheet_list'
	    else
	      render :action => 'stylesheet_upload'
	    end
	
	end
 end


end
