require 'fileutils'

def safe_copy(src, dest)
  if File.exists? dest
    puts "#{dest} exists... not overwriting..."
  else
    FileUtils.cp src, dest, :verbose => true
  end
end

plugin_root = File.dirname(__FILE__)
app_root = File.join(plugin_root, '../../../')

FileUtils.mkdir_p File.join(app_root, 'app/apis'), :verbose => true
FileUtils.mkdir_p File.join(app_root, 'vendor/gems'), :verbose => true

safe_copy File.join(plugin_root, 'templates/example_qbwc_controller.rb'), File.join(app_root, 'app/controllers/qbwc_controller.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc_helper.rb'), File.join(app_root, 'app/helpers/qbwc_helper.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc_api.rb'), File.join(app_root, 'app/apis/qbwc_api.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc_controller_test.rb'), File.join(app_root, 'test/functional/qbwc_controller_test.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc.qwc'), File.join(app_root, 'config/qbwc.qwc')
safe_copy File.join(plugin_root, 'lib/action_web_service_ext.rb'), File.join(app_root, 'lib/action_web_service_ext.rb')

FileUtils.cp_r File.join(plugin_root, 'vendor/actionwebservice'), File.join(app_root, 'vendor/gems/actionwebservice'), :preserve => true, :verbose => true

puts IO.read(File.join(File.dirname(__FILE__), 'README.markdown'))