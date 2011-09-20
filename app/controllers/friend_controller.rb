class FriendController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @contacts = Contact.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    
    @contact.user_id = session[:user].id
    if @contact.save
      flash[:notice] = 'Contact was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = 'Contact was successfully updated.'
      redirect_to :action => 'show', :id => @contact
    else
      render :action => 'edit'
    end
  end

  def destroy
    Contact.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

 	def contact_search
 	 	@contacts = Contact.find(:all, :conditions => ["user_id = ?", session[:user].id ])
 	end

	def search
		@contacts = Contact.find(:all,
			:conditions => ["lower(name) like ? AND user_id = ?",
		"%" + params[:search].downcase + "%", session[:user].id],  :order => 'name ASC')
		
		if params['search'].to_s.size < 1
			render :nothing => true
		else
			if @contacts.size > 0
				render :partial => 'contact', :collection => @contacts
			else
				render :text => "<li>No results found</li>", :layout => false
			end
		end
	end

end
