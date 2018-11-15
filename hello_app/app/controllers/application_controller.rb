class ApplicationController < ActionController::Base

  def hello
    render html: "¡Hola, Mundo!"	    
  end	

  def goodbye
    render html: "¡Good bye!"
  end
end
