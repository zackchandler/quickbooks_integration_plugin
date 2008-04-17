namespace :quickbooks_integration do

  desc 'Install template files for QuickBooks integration'
  task :setup do
    `ruby #{File.join(File.dirname(__FILE__), '../install.rb')}`
  end

end