class ViewerController < ApplicationController
	def index
		@user_name = params[:user_name]
		@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
		@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
		@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])
		@categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
		
		unless @categories.size > 0 then
				#selected content
				@category = Category.new
				@category.title = 'gallery'
				@category.id = params[:cid]
		else		
			########## selected content for side bar #######
			if params[:id]
				@id = params[:id]
				@category = Category.find(params[:id])
				@sidelinks = Webpage.find(:all, :conditions => ["category_id = ? AND publish = ? ", @category.id , true])
				# Webpage.find(@file_id)
			else
				# choose first content
				@category = Category.find(:first,:conditions => ["publish = ? AND user_id = ? ", true , @user]) 
				
				
				@sidelinks = Webpage.find(:all, :conditions => ["category_id = ? AND publish = ? ", @category.id , true])		
			end
			
			
			#select links for body
			if params[:body]
				@file_id = params[:body]
			else
				@file_id = @category.webpages.find(:first, :conditions => ["publish = ?", true])
			end
		end
	end
	
	def list
		for user in @users 
			link_to user.login, :action => 'index' , :user_name => user.login
		end
	end
	
 	def gallery
 		@user_name = params[:user_name]
 		@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
 	 	@photos = Photo.find(:all, :conditions => ["user_id = ?", @user ])
	  @categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
		
		@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
		@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])
	
		#selected content
		@category = Category.new
		@category.title = 'Photos'
		@category.id = params[:id]
			
 	end


	def image
		@image = Photo.find(params[:id])
		send_data @image.picture, :filename => @image.name + ".jpg",:type => @image.content_type, :disposition => "inline"
	end
	
	  def photo_show
 		@user_name = params[:user_name]
 		@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
	    @photo = Photo.find(params[:id])
	    @categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
			
		@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
		@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

		#selected content
		@category = Category.new
		@category.title = 'gallery'
		@category.id = params[:cid]
			
  end


  def blog_list
    @user_name = params[:user_name]
    @user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
    @blogs = Blog.find(:all, :conditions => ["user_id = ? and deleted_at is null AND hidden_at is null ", @user])
    @categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
		
	@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
	@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

	#selected content
	@category = Category.new
	@category.title = 'blogs'
	@category.id = params[:id]
		
 end

  def blog_show
    @blog = Blog.find(params[:id])
    @comment = Comment.new

    @user_name = params[:user_name]
    @user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
    
    @categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
		
	@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
	@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

	#selected content
	@category = Category.new
	@category.title = 'blog'
	@category.id = params[:cid]
		
  end

  def comment	
    @user_name = params[:user_name]
    @user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
    @blog= Blog.find(params[:id])
    @categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
		
	@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
	@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

	#selected content
	@category = Category.new
	@category.title = 'blog'
	@category.id = params[:cid]
		
	
  	#flash[:notice] = params[:id]
    @comment = Blog.find(params[:id]).comments.create(params[:comment])
    if @comment.save
      flash[:notice] = 'Added your comment.'
      redirect_to :action => "blog_show", :id => params[:id], :cid => -100 , 
      :user_name => @user_name
    else
      redirect_to :action => "blog_show", :id => params[:id], :cid => -100 , 
      :user_name => @user_name
    end
  end	

	  def profile
 		@user_name = params[:user_name]
 		@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
	    @categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
			

		@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
		@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

		#selected content
		@category = Category.new
		@category.title = 'about'
		@category.id = params[:id]
			
  end

  def song_list
    @user_name = params[:user_name]
	 	@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
    @songs = Song.find(:all, :conditions => ["user_id = ?", @user ])
		@categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
			
		@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
		@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])
	
		#selected content
		@category = Category.new
		@category.title = 'songs'
		@category.id = params[:id]
			
  end

  def video_list
    @user_name = params[:user_name]
	 	@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
    @videos = Video.find(:all, :conditions => ["user_id = ?", @user ])
		@categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
			
		@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
		@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])
	
		#selected content
		@category = Category.new
		@category.title = 'videos'
		@category.id = params[:id]
				
  end

  def song_show
    @song = Song.find(params[:id])
    @user_name = params[:user_name]
 	@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
	@categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
			
	@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
	@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

	#selected content
	@category = Category.new
	@category.title = 'about'
	@category.id = params[:cid]
			
  end

  def video_show
    @video = Video.find(params[:id])
    @user_name = params[:user_name]
 	@user = User.find(:all, :conditions => ["login = ?" ,@user_name ])
	@categories = Category.find(:all, :conditions => ["publish = ? AND user_id = ? ", true , @user])
			
	@headers = Header.find(:all, :conditions => ["user_id = ?" ,@user ])
	@footers = Footer.find(:all, :conditions => ["user_id = ?" ,@user ])

	#selected content
	@category = Category.new
	@category.title = 'about'
	@category.id = params[:cid]
			
  end

end
