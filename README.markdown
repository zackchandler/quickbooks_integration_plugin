
### Introduction ###

This plugin provides a webservice controller as a starting point for learning and implementing Rails/QuickBooks integration via the [QuickBooks Web Connector](http://marketplace.intuit.com/webconnector) (QBWC).

If you are just learning about QuickBooks integration you need to read and understand the [QBWC Programmers Guide](http://developer.intuit.com/qbSDK-current/doc/html/wwhelp/wwhimpl/js/html/wwhelp.htm).

### What this plugin provides ###

On installation this plugin creates the following files:

* app/controllers/qbwc_controller.rb
* app/apis/qbwc_api.rb
* app/helpers/qbwc_helper.rb
* test/functional/qbwc_controller\_test.rb
* config/qbwc.qwc

The QbwcController includes a very simple example of querying QuickBooks and displaying a customer list.

To implement your own QuickBooks integration, implement the functions outlined in the QbwcController according to your integration needs.

### Requirements ###

1) Add a route for the qbwc controller to config/routes.rb

	# example Quickbooks Web Connector api route
	map.quickbooks_api 'apis/quickbooks/api', :controller => 'qbwc', :action => 'api'

2) Add the following block to config/environment.rb

    Rails::Initializer.run do |config|
      ...
      config.load_paths += %W( #{RAILS_ROOT}/app/apis )
      config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
        File.directory?(lib = "#{dir}/lib") ? lib : dir
      end
      ...
    end

3) Add the following lines to an initializer or the bottom of config/environment.rb

    require 'actionwebservice'
    require 'action_web_service_ext'

4) The QBWC will only communicate over SSL so make sure your app has a valid and trusted SSL cert installed.  For testing the QBWC will speak to localhost over http.

### Installation ###

	$ ./script/plugin install git://github.com/zackchandler/quickbooks_integration_plugin.git

Upon installation, the template files will be copied over to your app.

If you want to copy over the template files again, use the following rake task:

	$ rake quickbooks_integration:setup
	
Note: The rake task will not overwrite any existing files.

### Development Strategies ###

I develop on a Mac and run QuickBooks via [Parallels Desktop for Mac](http://www.parallels.com/en/products/desktop).  To setup an development environment using a Mac + Parallels do the following:

1. Open Windows instance in Parallels
2. Install QuickBooks
3. Install the [QBWC](http://marketplace.intuit.com/webconnector)
4. Modify hosts file (c:\WINDOWS\system32\drivers\etc\hosts) to point localhost1 to Mac's IP:

		# replace IP address below with your Mac's IP address
		192.168.0.3 localhost1

5. Open a QuickBooks company file (you can use one of the QuickBooks example company files)
6. Copy qbwc.qwc file to Windows instance and double-click to install apps configuration in the QBWC
7. Start up Rails app with ./script/server
8. Tail your log/development.log file to see communication cycle
9. Check box on QBWC next to app's listing and click 'Update selected' button
10. Watch qbxml messages sent back and forth...

### Help ###

Getting up to speed on QuickBooks can be challenging.  I would highly recommend posting questions to the excellent [IDN forums](http://idnforums.intuit.com) if you get stuck.
		
### References ###

[QBWC Programmers Guide](http://developer.intuit.com/qbSDK-current/doc/html/wwhelp/wwhimpl/js/html/wwhelp.htm)  
[QBXML Messages](http://developer.intuit.com/qbSDK-current/OSR/OnscreenRef/index-QBD.html)  
[QuickBooks SDK Manuals](http://developer.intuit.com/QuickBooksSDK/chart.asp?id=94)  
[IDN Forums](http://idnforums.intuit.com)  
[QuickBooks Web Connector](http://marketplace.intuit.com/webconnector)
