	class StylesheetController < ApplicationController
  layout 'main'	
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @stylesheets = Stylesheet.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def menu
    @stylesheets = Stylesheet.find(:all)
    @user = User.find(session[:user].id)
    @selected = Stylesheet.find(@user.stylesheet_id)
  end

  def chosen
    @stylesheets = Stylesheet.find(:all, :conditions => ["user_id = ?", session[:user].id ])
    @user = User.find(session[:user].id)
    @selected = Stylesheet.find(@user.stylesheet_id)
  end

  def show
    @stylesheet = Stylesheet.find(params[:id])
  end

  def new
    @stylesheet = Stylesheet.new
  end

  def create
    @stylesheet = Stylesheet.new(params[:stylesheet])
    @stylesheet.user_id = session[:user].id
    if @stylesheet.save
      flash[:notice] = 'Stylesheet was successfully created.'
    	@id =session[:user].id
	    @user = User.find( id  )
	    @user.stylesheet_id =@stylesheet.id 
	    if @user.save
	      redirect_to :action => 'chosen', :id => "#{session[:user].id}"
    	else
    		redirect_to :action => 'menu'
    	end
    else
      render :action => 'new'
    end
  end

  def upload
    @stylesheet = Stylesheet.new
  end

  def createupload
  	unless params[:stylesheet][:name].size > 0
      flash[:notice] = 'Failed uploading. You should select some files to upload.'
      redirect_to :action => 'stylesheet_upload'
  	else
	    @stylesheet = Stylesheet.new(params[:stylesheet])
	    @stylesheet.css = @params['stylesheet']['name'].read
		@stylesheet.user_id = session[:user].id
	  	@stylesheet.name = params[:stylesheet][:name].original_filename
	  	#@stylesheet.content_type = params[:stylesheet][:name].content_type
	  	#Directory path
		@filefolder = "#{RAILS_ROOT}/public/stylesheets"
	
	  	if @stylesheet.save
		    File.open("#{@filefolder}/#{@stylesheet.name}", "wb") do |f| 
		      f.write(@params['stylesheet']['name'].read)
	    	end
		      flash[:notice] = 'Stylesheet was successfully created.'
		      redirect_to :action => 'list'
	    else
	      render :action => 'upload'
	    end
	
	end
 end


  def edit
    @stylesheet = Stylesheet.find(params[:id])
  end

  def update
    @stylesheet = Stylesheet.find(params[:id])
    
    if @stylesheet.update_attributes(params[:stylesheet])
      flash[:notice] = 'Stylesheet was successfully updated.'
      redirect_to :action => 'show', :id => @stylesheet
    else
      render :action => 'edit'
    end
  end

  def style_update
  	@stylesheet = Stylesheet.find(params[:stylesheet][:id])
    @user = User.find(session[:user].id)
    @user.stylesheet_id = @stylesheet.id
    
    if @user.save
    	flash[:notice] = 'Stylesheet was successfully updated.'
    	redirect_to :action => 'chosen', :id => "#{session[:user].id}"
    end
  end

  def destroy
    
    if session[:user].stylesheet_id =params[:id]
    	Stylesheet.find(params[:id]).destroy
	    @user = User.find(session[:user].id)
	    @user.stylesheet_id =Stylesheet.find(:first).id 
	    @user.save
	end    	
      		
    redirect_to :action => 'list'
  end
  
end
