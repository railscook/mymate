class FooterController < ApplicationController
  layout 'main'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @footers = Footer.find(:all, :conditions => ["user_id = ?", session[:user].id ])
  end

  def show
    @footer = Footer.find(params[:id])
  end

  def new
    @footer = Footer.new
  end

  def create
    @footer = Footer.new(params[:footer])
    @footer.user_id = session[:user].id
    if @footer.save
      flash[:notice] = 'Footer was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @footer = Footer.find(params[:id])
  end

  def update
    @footer = Footer.find(params[:id])
    if @footer.update_attributes(params[:footer])
      flash[:notice] = 'Footer was successfully updated.'
      redirect_to :action => 'show', :id => @footer
    else
      render :action => 'edit'
    end
  end

  def destroy
    Footer.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
