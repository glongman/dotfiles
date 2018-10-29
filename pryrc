ActiveRecord::Base.logger = Logger.new STDOUT
begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
rescue LoadError => err
  puts "no awesome_print :("
end

# load Rails Console Helpers
require 'rails/console/app'
extend Rails::ConsoleMethods
puts "Rails console helpers added"
 
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
# Pry.commands.alias_command 'f', 'finish'
Pry.commands.alias_command 'l', 'whereami'
