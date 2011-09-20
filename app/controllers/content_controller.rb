class ContentController < ApplicationController
  layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :moveup ],
         :redirect_to => { :action => :list }

  def list
    @content_pages, @contents = paginate :contents, :per_page => 50
    @contents = Content.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def manage
    @content_pages, @contents = paginate :contents, :per_page => 50
    @contents = Content.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @content = Content.find(params[:id])
  end

  def category_new
  	@content = Content.new
  end

  def new
    @content = Content.new(params[:content])
    @content.user_id = session[:user].id
    @content.publish = true

  	#Directory path
  	if @content.title == "home" 
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
  	else
  		@filefolder = 
  		"#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@content.title}"
  	end
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

    if @content.save
    	#return if request.xhr? 
	    return render :action => 'new.rjs' if request.xhr?
    	render :partial => 'content', :object => @content
    end
  end

  def delete    
    @content = Content.find(params[:id]) 
    @content.destroy
	for file in @content.create_new_files    
	    file.destroy
	    File.delete("#{RAILS_ROOT}/public#{file.url}") if 	File.exist?("#{RAILS_ROOT}/public#{file.url}")
	end

    @filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@content.title}"
    Dir.rmdir "#{@filefolder}"
	
	return if request.xhr? 
	#return render :action => 'delete.rjs' if request.xhr?
    render :nothing, :status => 200 
  end 

  def create
    @content = Content.new(params[:content])
    @content.user_id = session[:user].id

  	#Directory path
  	if @content.title == "home" 
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
  	else
  		@filefolder = 
  		"#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@content.title}"
  	end
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

    if @content.save
      flash[:notice] = 'Content was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @content = Content.find(params[:id])
  end

  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      flash[:notice] = 'Content was successfully updated.'
      redirect_to :action => 'show', :id => @content
    else
      render :action => 'edit'
    end
  end

  def destroy
    Content.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  protected 
  def logged_in? 
    unless session[:user] 
      redirect_to :controller => 'cms'
    else 
      return true 
    end 
  end 
  
  def moveup
    @content = Content.find(params[:id])
      redirect_to :action => 'list'
  end
end
