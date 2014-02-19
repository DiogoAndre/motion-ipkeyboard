unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'RMIPKeyboard/*.rb')).each do |file|
    app.files.unshift(file)
    app.resources_dirs << File.join(File.dirname(__FILE__), 'RMIPKeyboard/resources')
  end
end