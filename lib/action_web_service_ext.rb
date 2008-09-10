module ActionController
  class Base
      
    alias_method :old_dispatch_web_service_request, :dispatch_web_service_request
      
    # --- [ QBWC requests the api url with a GET request upon loading the QWC file for the first time ] ---
    def dispatch_web_service_request
      render :nothing => true and return if request.get?
      old_dispatch_web_service_request
    end
    
  end
end
