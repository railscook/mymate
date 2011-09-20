# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mark_up(body)
   line_break(body.gsub(/\nhttp:\/\/(.*)\r\n/, '<br/><a target="_blank" href="http://\1"><img src="/images/external_link_icon.png"/>Link</a>'))
  end

  def line_break(body)
	body.gsub("\n", "<br/>")
  end
  
  def logged_in? 
    if session[:user] 
    	return true 
    else
    	redirect_to :controller => "login", :action => "signin"	
	    return false
	  end
  end 
  
  def admin_logged_in? 
    if session[:admin] 
    	return true 
    else
    	redirect_to :controller => "login", :action => "signin"	
    	return false
    end
  end 

	def fckeditor_text_field(object, method, options = {})
	    text_area(object, method, options ) +
	    javascript_tag( "var oFCKeditor = new FCKeditor('" + object + "_" + method + 
	    "');oFCKeditor.ReplaceTextarea()" )
	end 

  def ellipsis(text, size)
    if text.size > size
      text[0..size] + link_to_function('<b>...</b>', "alert('#{text}')", :style => 'cursor: help', :title => text)
    else
      text
    end
  end
	 
end
