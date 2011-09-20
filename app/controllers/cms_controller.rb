class CmsController < ApplicationController
	layout 'main'
  def faq
   @faq = Faq.find(:all)
  end
end
