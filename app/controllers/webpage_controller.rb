class WebpageController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
 	 @categories = Category.find(:all, :conditions => [" user_id = ?", session[:user].id])
 	 @total = 0
	for category in @categories
		@webpages  = category.webpages
		for webpage in @webpages
			@total  += 1
		end
	end
  end

  def published
 	 @categories = Category.find(:all, :conditions => [" user_id = ?", session[:user].id])
 	 @total = 0
	for category in @categories
		@webpages  = category.webpages
		for webpage in @webpages
			@total  += 1
		end
	end
  end
  
  def show
    @webpage = Webpage.find(params[:id])
  end

  def new
    @webpage = Webpage.new
    @categories = Category.find(:all, :conditions => ["user_id = ?",  session[:user].id])
  end

  def create
  	#Get all contents to get a list of content
  	@categories = Category.find(:all)
    @webpage = Webpage.new(params[:webpage])
    #@webpage.user_id = session[:user].id
    @webpage.publish = 1
    @webpage.content_type = "text/rhtml"
    @filename = @webpage.file_name + ".rhtml"

	#Selected Category id and name
  	@category_id = params[:webpage][:category_id]
  	@category = Category.find(@category_id)

  	#Directory path
  	if @category.title == "home" 
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
  		@webpage.url = "/Users/#{session[:user].login}/#{@filename}"
  	else
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@category.title}"
  		@webpage.url = "/Users/#{session[:user].login}/#{@category.title}/#{@filename}"
  	end
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

  	@text = @webpage.text
    #@pagelayout = Pagelayout.find(1)
 	#@header = Header.find(@pagelayout.header_id).html 
 	#@footer = Footer.find(@pagelayout.footer_id).html 
 	@stylesheet = Stylesheet.find(:first).name 

  	if @webpage.save
	    File.open("#{@filefolder}/#{@filename}", "wb") do |outs| 
	    	outs.puts  " #{@text} "
    	end
	      flash[:notice] = 'webpage was successfully created.'
	      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
    
    end
    
  def upload
    @webpage = Webpage.new
    @categories = Category.find(:all, :conditions => ["user_id = ?",  session[:user].id])
  end

  def createupload
  	unless params[:webpage][:url].size > 0
      flash[:notice] = 'Failed uploading. You should select some files to upload.'
      redirect_to :action => 'upload'
 		
  	else
  	
  	#Get all contents 
  	#Parameter pass assigning
  	@categories = Category.find(:all)
    @webpage = Webpage.new(params[:webpage])
    #@webpage.user_id = session[:user].id
    @webpage.text = @params['webpage']['url'].read
  	@webpage.file_name = params[:webpage][:url].original_filename
  	@webpage.content_type = params[:webpage][:url].content_type
  	@webpage.description = @webpage.file_name 
  	@webpage.publish = 1
  	#@webpage.content_title = @webpage.file_name 
  	@filename = @webpage.file_name
  	
  	
  	@webpage.file_name = @filename
  		
	#Selected Category id and name
  	@category_id = params[:webpage][:category_id]
  	@category = Category.find(@category_id)

  	#Directory path
  	if @category.title == "home" 
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
  		@webpage.url = "/Users/#{session[:user].login}/#{@filename}"
  	else
  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@category.title}"
  		@webpage.url = "/Users/#{session[:user].login}/#{@category.title}/#{@filename}"
  	end
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

  	if @webpage.save
	    File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
	      	
	      f.write(@params['webpage']['url'].read)
    	end
	      flash[:notice] = 'Webpage was successfully created.'
	      redirect_to :action => 'list'
    else
      render :action => 'upload'
    end
	
	end
  end

  def edit
    @webpage = Webpage.find(params[:id])
    @categories = Category.find(:all, :conditions => ["user_id = ?",  session[:user].id])
  end

  def update
  	
    @categories = Category.find(:all)
    @webpage = Webpage.find(params[:id])
    @filename = @webpage.file_name

  	@text = params[:webpage][:text]

    @file_old_url = @webpage.url
  	@category_old_id = @webpage.category_id
  	@category_old = Category.find(@category_old_id)
    
  	@category_new_id = params[:webpage][:category_id]
  	@category_new = Category.find(@category_new_id)

  	unless @category_new_id == @category_old_id # Change folder, need to do update
  		if @category_new.title == "home" 
	  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}"
	  		@webpage.url = "/Users/#{session[:user].login}/#{@filename}"
	  	else
	  		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/#{@category_new.title}"
	  		@webpage.url = "/Users/#{session[:user].login}/#{@category_new.title}/#{@filename}"
	  	end
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end
	end
    
	@file_old_url = 'public' + @file_old_url
	@file_new_url = 'public' + @webpage.url

    if @webpage.update_attributes(params[:webpage])
	    File.open("#{@filefolder}/#{@filename}", "wb") do |outs| 
	    	outs.puts  " #{@text} "
    	end

    	unless @file_old_url == @file_new_url # Change folder, need to do update
    		FileUtils.mv @file_old_url, @file_new_url
		end

      flash[:notice] = 'Create new file was successfully updated.'
      redirect_to :action => 'show', :id => @webpage
    else
      render :action => 'edit'
    end
 end

  def destroy
 	@file = Webpage.find(params[:id])
    Webpage.find(params[:id]).destroy
    File.delete("#{RAILS_ROOT}/public#{@file.url}") if 	File.exist?("#{RAILS_ROOT}/public#{@file.url}")
    redirect_to :action => 'list'
  end

	def sitemap
		@categories = Category.find(:all, :conditions => ["user_id = ?",  session[:user].id])
		
	end
	
 	def web_search
 	 @categories = Category.find(:all, :conditions => [" user_id = ?", session[:user].id])
	for category in @categories
		@webpages  = category.webpages
	end

 	end

	def search
	 @categories = Category.find(:all, :conditions => [" user_id = ?", session[:user].id])
     @webpages = Webpage.find(:all,
			:conditions => ["lower(description) like ? ",
		"%" + params[:search].downcase + "%"], :order => 'description ASC')
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @webpages.size > 0
				
				render :partial => 'webpage', :collection => @webpages
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end

  def edit_publish
    @webpage = Webpage.find(params[:id])
  end
  
  def update_publication
    @webpage = Webpage.find(params[:id])
    if @webpage.update_attributes(params[:webpage])
      #flash[:notice] = 'Publication of a selected web page was successfully updated.'
      flash[:notice] =params[:webpage][:publish]
      redirect_to :action => 'published'
    else
      flash[:notice] = 'Fail update publication!'
      render :action => 'edit_publish', :id => @webpage
    end
  	
  end


end