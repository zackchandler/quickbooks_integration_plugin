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
safe_copy File.join(plugin_root, 'templates/example_qbwc_controller.rb'), File.join(app_root, 'app/controllers/qbwc_controller.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc_helper.rb'), File.join(app_root, 'app/helpers/qbwc_helper.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc_api.rb'), File.join(app_root, 'app/apis/qbwc_api.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc_controller_test.rb'), File.join(app_root, 'test/functional/qbwc_controller_test.rb')
safe_copy File.join(plugin_root, 'templates/example_qbwc.qwc'), File.join(app_root, 'config/qbwc.qwc')

puts IO.read(File.join(File.dirname(__FILE__), 'README'))