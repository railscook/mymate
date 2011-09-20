class PhotoController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'gallery'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @photos = Photo.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create 
  	#Parameter pass assigning
  	
  	unless params[:photo][:url].size > 0
      flash[:notice] = 'Failed uploading. You should select some photos to upload.'
      redirect_to :action => 'new'
 		
  	else
    @photo = Photo.new(params[:photo])
  	@photo.picture_name = params[:photo][:url].original_filename
  	@photo.content_type = params[:photo][:url].content_type
  	@photo.user_id = session[:user].id
 	
  	#Directory path
	@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/images"
	@photo.url = "/Users/#{session[:user].login}/images/#{@photo.picture_name}"
  	
	    # Check to see if it exists
	    unless File.exists?(@filefolder)
	      Dir.mkdir "#{@filefolder}"
	    end

  	if @photo.save
	    File.open("#{@filefolder}/#{@photo.picture_name}", "wb") do |f| 
	      f.write(params['photo']['url'].read)
    	end
	      flash[:notice] = 'Photo was successfully created.'
	      redirect_to :action => 'show', :id => @photo.id
    else
      flash[:notice] = 'Failed.'
      render :action => 'new'
    end
	end
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
  	
  	unless params[:photo][:url].size > 0
  	  @photo = Photo.find(params[:id])
      flash[:notice] = 'Failed updating. You should select some photos to edit.'
      redirect_to :action => 'edit', :id => @photo
 		
  	else

  	#Parameter pass assigning
    @old_photo = Photo.find(params[:id])
  	#delete old image phyiscally
    # Not totally destroy Photo.find(params[:id]).destroy 
    # Physically delete
    File.delete("#{RAILS_ROOT}/public#{@old_photo.url}") if 	File.exist?("#{RAILS_ROOT}/public#{@old_photo.url}")
  	@photo = @old_photo
  	@photo.picture_name = params[:photo][:url].original_filename
  	@photo.content_type = params[:photo][:url].content_type
  	@photo.user_id = session[:user].id
  	#Directory path
  	@filefolder = "#{RAILS_ROOT}/public/Users/#{session[:user].login}/images"
	@photo.url = "/Users/#{session[:user].login}/images/#{@photo.picture_name}"
  	if @photo.save
	    File.open("#{@filefolder}/#{@photo.picture_name}", "wb") do |f| 
	      f.write(@params['photo']['url'].read)
    	end
	      flash[:notice] = 'photo was successfully updated.'
	      redirect_to :action => 'show', :id => @photo
    else
    	flash[:notice] = 'Failed.'
      redirect_to :action => 'edit', :id => @photo
    end
  end
  end

  def destroy
	#Delete in database
    @photo = Photo.find(params[:id])
    @photo.destroy
    # Physically delete
    File.delete("#{RAILS_ROOT}/public#{@photo.url}") if 	File.exist?("#{RAILS_ROOT}/public#{@photo.url}")

    redirect_to :action => 'list'
  end


	def email
	@photo = Photo.find(params[:id])
	
	url = "#{request.env["SERVER_NAME"]}/photo/image/#{@photo.id}"
		if request.post?
		#ClassifiedMailer.deliver_classified_with_attachment(params[:user][:email], @photo, url)
		end
 	end
 	
 	def gallery
 	 	@photos = Photo.find(:all, :conditions => ["user_id = ?", session[:user].id ])
 	end
	
 	def photo_search
 	 	@photos = Photo.find(:all, :conditions => ["user_id = ?", session[:user].id ])
 	end

	def search
		@photos = Photo.find(:all,
			:conditions => ["lower(picture_name) like ? AND user_id = ?",
		"%" + params[:search].downcase + "%", session[:user].id],  :order => 'picture_name ASC')
		
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @photos.size > 0
				render :partial => 'photo', :collection => @photos
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end
	
end
