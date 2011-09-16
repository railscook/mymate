class UserController < ApplicationController
	layout 'main'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @users = User.find(:all)
  end

	def show
		@user = User.find(:first, :conditions => ["login = ?", params[:login]])
	end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.pw = params[:user][:password]
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      SharedMailer.deliver_updated_account :user => @user
      redirect_to :action => 'show', :login => @user.login
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
