class HeaderController < ApplicationController
	layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @headers = Header.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @header = Header.find(params[:id])
  end

  def new
    @header = Header.new
  end

  def create
    @header = Header.new(params[:header])
    @header.user_id = session[:user].id
    if @header.save
      flash[:notice] = 'Header was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @header = Header.find(params[:id])
  end

  def update
    @header = Header.find(params[:id])
    if @header.update_attributes(params[:header])
      flash[:notice] = 'Header was successfully updated.'
      redirect_to :action => 'show', :id => @header
    else
      render :action => 'edit'
    end
  end

  def destroy
    Header.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
