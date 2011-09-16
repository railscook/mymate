class FileclassifiedController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  	@default = 15
    @fileclassifieds = Fileclassified.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end


  def show
    @fileclassified = Fileclassified.find(params[:id])
  end

  def new
    @fileclassified = Fileclassified.new
  end

  def create_testing
    @fileclassified = Fileclassified.new(params[:fileclassified])
        @filename = params[:fileclassified][:url].original_filename

        #Data Type
        @fileclassified.name = @filename
        @fileclassified.content_type = params[:fileclassified][:url].content_type
        @fileclassified.user_id = session[:user].id

        #Directory path
        @filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/files/"
        @fileclassified.url = "/Users/#{session[:user].login}/files/#{@filename}"
            unless File.exists?(@filefolder)
              Dir.mkdir "#{@filefolder}"
            end

       if @fileclassified.save
           #render :text => "#{@filefolder}/#{@filename}"

           File.open("#{@filefolder}/#{@filename}", "wb") do |f|
             #render :text => "#{@filefolder}/#{@filename}"
   
            #f.write(@params['fileclassified']['url'].read)
            render :text => "#{params[:fileclassified][:url].class.to_s}"
           end
       end

   #render :text => "#{@filefolder}/#{@filename}"
  end

  def create
  	unless params[:fileclassified][:url].size > 0
      flash[:notice] = 'Failed uploading. You should select some files to upload.'
      redirect_to :action => 'new'
 		
  	else

  	#Get all categories 
  	#Parameter pass assigning
    @fileclassified = Fileclassified.new(params[:fileclassified])
  	@filename = params[:fileclassified][:url].original_filename
  	
  	#Data Type 
  	@fileclassified.name = @filename
  	@fileclassified.content_type = params[:fileclassified][:url].content_type
  	@fileclassified.user_id = session[:user].id
 	
  	#Directory path
	@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/files/"
	@fileclassified.url = "/Users/#{session[:user].login}/files/#{@filename}"
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

  	if @fileclassified.save
	    #File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
	    #  f.write(@params['fileclassified']['url'].read)
    	    #end
	      flash[:notice] = 'Fileclassified was successfully created.'
	      redirect_to :action => 'show', :id => @fileclassified.id
    else
      render :action => 'new'
    end
	end
  end

  def edit
    @fileclassified = Fileclassified.find(params[:id])
  end

  def update
  	
  	unless params[:fileclassified][:url].size > 0
      @fileclassified = Fileclassified.find(params[:id])
      flash[:notice] = 'Failed updating. You should select some files to edit.'
      redirect_to :action => 'edit', :id => @fileclassified
 		
  	else

  	#Parameter pass assigning
    @old_fileclassified = Fileclassified.find(params[:id])

  	#delete old image phyiscally
    # Not totally destroy Fileclassified.find(params[:id]).destroy 
    # Physically delete
    File.delete("#{RAILS_ROOT}/public#{@old_fileclassified.url}") if 	File.exist?("#{RAILS_ROOT}/public#{@old_fileclassified.url}")

  	@fileclassified = @old_fileclassified
  	@filename = params[:fileclassified][:url].original_filename

  	#Data Type 
  	@fileclassified.name = @filename
  	@fileclassified.content_type = params[:fileclassified][:url].content_type
  	@fileclassified.user_id = session[:user].id
 	
  	#Directory path
	@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/files/"
	@fileclassified.url = "/Users/#{session[:user].login}/files/#{@filename}"

  	if @fileclassified.save
	    File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
	      f.write(@params['fileclassified']['url'].read)
    	end
	      flash[:notice] = 'Fileclassified was successfully created.'
	      redirect_to :action => 'show', :id => @fileclassified.id
    else
    	flash[:notice] = 'Failed.'
      redirect_to :action => 'edit', :id => @fileclassified
    end
	end
  end

  def destroy
  	@fileclassified = Fileclassified.find(params[:id])
    Fileclassified.find(params[:id]).destroy
    File.delete("#{RAILS_ROOT}/public#{@fileclassified.url}") if 	File.exist?("#{RAILS_ROOT}/public#{@fileclassified.url}")
    redirect_to :action => 'list'
  end

  def file_search
  	@default = 15
 	 	@fileclassifieds = Fileclassified.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

	def search
		@fileclassifieds = Fileclassified.find(:all,
			:conditions => ["lower(name) like ? AND user_id = ?",
		"%" + params[:search].downcase + "%", session[:user].id],  :order => 'name ASC')
		
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @fileclassifieds.size > 0
				render :partial => 'fileclassified', :collection => @fileclassifieds
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end

end
