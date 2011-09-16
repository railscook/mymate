class SongController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @songs = Song.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def create
  	unless params[:song][:url].size > 0
      flash[:notice] = 'Failed uploading. You should select some songs to upload.'
      redirect_to :action => 'new'
 		
  	else
  	
	  	#Parameter pass assigning
	    @song = Song.new(params[:song])
	  	@filename = @song.url.original_filename
	  	@content_type = params[:song][:url].content_type
	  	@song.content_type = @content_type
	  	@song.title = params[:song][:title]
	  	@song.user_id = session[:user].id
	 	@song.description = "This is a song called " + @filename 
	  	#Directory path
		@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/songs"
		@song.url = "/Users/#{session[:user].login}/songs/#{@filename}"
	  	
		    # Check to see if it exists
		    unless File.exists?(@filefolder)
		      Dir.mkdir "#{@filefolder}"
		    end
	
	  	if @song.save
		    File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
		      f.write(@params['song']['url'].read)
	    	end
		      flash[:notice] = 'Song was successfully created.'
		      redirect_to :action => 'show', :id => @song.id
	    else
	      render :action => 'new'
	    end
	    
	end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
	  	unless params[:song][:url].size > 0
	  	  @song = Song.find(params[:id])	
	      flash[:notice] = 'Failed uploading. You should select some songs to upload.'
	      redirect_to :action => 'edit', :id => @song
	 		
	  	else
		  	#Parameter pass assigning
		    @old_song = Song.find(params[:id])
		  	#delete old song phyiscally
		    # Physically delete
		    File.delete("#{RAILS_ROOT}/public#{@old_song.url}") if 		File.exist?("#{RAILS_ROOT}/public#{@old_song.url}")
		  	@song = @old_song
		  	@filename= params[:song][:url].original_filename
		  	@song.title = params[:song][:title]
		  	@song.user_id = session[:user].id
		  	#Directory path
		  	@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/songs"
			@song.url = "/Users/#{session[:user].login}/songs/#{@filename}"
		  	if @song.save
			    File.open("#{@filefolder}/#{@filename}", "wb") do |f| 
			      f.write(@params['song']['url'].read)
		    	end
			      flash[:notice] = 'Song was successfully updated.'
			      redirect_to :action => 'show', :id => @song
		    else
		      redirect_to :action => 'edit', :id => @song
		    end
	  end
  end

  def destroy
    @song = Song.find(params[:id])
    @song .destroy
    File.delete("#{RAILS_ROOT}/public#{@song.url}") if 	File.exist?("#{RAILS_ROOT}/public#{@song.url}")
    redirect_to :action => 'list'
  end

 	def song_search
 	 	@songs = Song.find(:all, :conditions => ["user_id = ?", session[:user].id ])
 	end

	def search
		@songs = Song.find(:all,
			:conditions => ["lower(title) like ? AND user_id = ?",
		"%" + params[:search].downcase + "%", session[:user].id],  :order => 'title ASC')
		
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @songs.size > 0
				render :partial => 'song', :collection => @songs
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end
end
