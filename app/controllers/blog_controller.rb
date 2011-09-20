class BlogController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :comment ],
         :redirect_to => { :action => :list }

  def list
    @blogs = Blog.find(:all, :conditions => ["user_id = ? AND deleted_at is NULL", session[:user].id ], :order => "id ASC") 
  end

  def show
    @blog = Blog.find(params[:id])
    @comment = Comment.new
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(params[:blog])
    @blog.user_id = session[:user].id

   if @blog.save
     flash[:notice] = 'Blog was successfully created.'
     redirect_to :action => 'list'
   else
     render :action => 'new'
   end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(params[:blog])
      flash[:notice] = 'Blog was successfully updated.'
      redirect_to :action => 'show', :id => @blog
    else
      render :action => 'edit'
    end
  end

  def change_hide_status
   @blog = Blog.find(params[:id])
   if @blog.hidden_at
    @blog.update_attribute(:hidden_at, nil)
   else
    @blog.update_attribute(:hidden_at, Time.now())
   end
   redirect_to :action => 'list'
  end

  def destroy
   @blog = Blog.find(params[:id])
   @blog.update_attribute(:deleted_at, Time.now())
    redirect_to :action => 'list'
  end


  def comment	
  	@blog = Blog.find(params[:id])
    @comment = Blog.find(params[:id]).comments.create(params[:comment])
    if @comment.save
      flash[:notice] = 'Added your comment.'
      redirect_to :action => "show", :id => params[:id]
    else
      redirect_to :action => "show", :id => params[:id]
    end
  end	

  def destroy_comment
  	@comment = Comment.find(params[:id])
  	@blog = Blog.find(@comment.blog_id)
  	@comment.destroy
    redirect_to :action => 'show', :id => @blog.id
  end

 	def blog_search
 		@blogs = Blog.find(:all, :conditions => ["user_id = ?", session[:user].id ], :limit => 10, :order => 'id desc')
 	end

	def search
		@blogs = Blog.find(:all,
			:conditions => ["(lower(title) like ? OR lower(body) like ?) AND user_id = ? AND deleted_at is null",
		"%" + params[:search].downcase + "%", "%" + params[:search].downcase + "%", session[:user].id],  :order => 'title ASC')
		
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @blogs.size > 0
				render :partial => 'myblog'#, :collection => @blogs
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end
end

  




