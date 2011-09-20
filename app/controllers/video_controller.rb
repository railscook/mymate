class VideoController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @videos = Video.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @video = Video.find(params[:id])
  end
	
  def new
    @video = Video.new
  end

	def create
  	unless params[:video][:url].size > 0
      flash[:notice] = 'Failed uploading. You should select some videos to upload.'
      redirect_to :action => 'new'
 		
  	else

  	#Parameter pass assigning
    @video = Video.new(params[:video])
  	@filename = @video.url.original_filename
  	@content_type = params[:video][:url].content_type
  	@video.content_type = @content_type
  	@video.title = params[:video][:title]
  	@video.user_id = session[:user].id
	 	@video.description = "This is a video called " + @filename 
	  	#Directory path
		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/videos"
		@video.url = "/Users/#{session[:user].login}/videos/#{@filename}"
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

  	if @video.save
	    File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
	      f.write(@params['video']['url'].read)
    	end
	      flash[:notice] = 'Video was successfully created.'
	      redirect_to :action => 'show', :id => @video.id
    else
      render :action => 'new'
    end
	end
  end

  def update
  	unless params[:video][:url].size > 0
  	  @video = Video.find(params[:id])	
      flash[:notice] = 'Failed updating. You should select some videos to edit.'
      redirect_to :action => 'edit', :id => @video 
 		
  	else
  	
	  	#Parameter pass assigning
	    @old_video = Video.find(params[:id])
	  	#delete old video phyiscally
	    # Physically delete
	    File.delete("#{RAILS_ROOT}/public#{@old_video.url}") if 		File.exist?("#{RAILS_ROOT}/public#{@old_video.url}")
	  	@video = @old_video
	  	@filename= params[:video][:url].original_filename
	  	@video.title = params[:video][:title]
	  	@video.user_id = session[:user].id
	  	#Directory path
	  	@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/videos"
		@video.url = "/Users/#{session[:user].login}/videos/#{@filename}"
	  	if @video.save
		    File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
		      f.write(@params['video']['url'].read)
	    	end
		      flash[:notice] = 'Video was successfully updated.'
		      redirect_to :action => 'show', :id => @video
	    else
	      redirect_to :action => 'edit', :id => @video
	    end
	end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def destroy
    Video.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

 	def video_search
 	 	@videos = Video.find(:all, :conditions => ["user_id = ?", session[:user].id ])
 	end

	def search
		@videos = Video.find(:all,
			:conditions => ["lower(title) like ? AND user_id = ?",
		"%" + params[:search].downcase + "%", session[:user].id],  :order => 'title ASC')
		
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @videos.size > 0
				render :partial => 'video', :collection => @videos
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end
end
