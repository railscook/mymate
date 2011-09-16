module ViewerHelper
  def logged_in? 
    if session[:user] 
    	return true 
    else
    	redirect_to :controller => "login", :action => "signin"	
	    return false
	  end
  end 
  
	
end
