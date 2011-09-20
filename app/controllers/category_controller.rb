class CategoryController < ApplicationController
  layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :moveup ],
         :redirect_to => { :action => :list }

  def list
    @categories = Category.find(:all, :conditions => ["user_id = ?", session[:user].id ])
    
    #@user = User.find(session[:user])
    #@categories = @user.categories
  end

  def manage
    @categories = Category.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @category = Category.find(params[:id])
  end

  def category_new
  	@category = Category.new
  end

  def new
kjkk
    @category = Category.new(params[:category])
    @category.user_id = session[:user].id
    @category.publish = true

  	#Directory path
  	if @category.title == "home" 
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
  	else
  		@filefolder = 
  		"#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@category.title}"
  	end
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

    if @category.save
    	#return if request.xhr? 
	return render :action => 'new.rjs' if request.xhr?
    	render :partial => 'category', :object => @category
    else
        render :action => "new"
    end
  end

  def delete    
    @category = Category.find(params[:id]) 
    @category.destroy
	for file in @category.webpages   
	    file.destroy
	    File.delete("#{RAILS_ROOT}/public#{file.url}") if 	File.exist?("#{RAILS_ROOT}/public#{file.url}")
	end

    @filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@category.title}"
    Dir.rmdir "#{@filefolder}"
	
	#return if request.xhr? 
	return render :action => 'delete.rjs' if request.xhr?
    render :nothing, :status => 200 
  end 

  def create
    @category = Category.new(params[:category])
    @category.user_id = session[:user].id

  	#Directory path
  	if @category.title == "home" 
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
  	else
  		@filefolder = 
  		"#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@category.title}"
  	end
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'show', :id => @category
    else
      render :action => 'edit'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
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
    @category = Category.find(params[:id])
      redirect_to :action => 'list'
  end
end
