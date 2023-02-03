#!/usr/bin/ruby
require 'irb/completion'
require 'irb/ext/save-history'
require 'awesome_print'
require 'irb'


AwesomePrint.irb!
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:USE_COLORIZE] = false
IRB.conf[:USE_AUTOCOMPLETE] = false

%w[rubygems looksee].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
  
  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    system 'ri', method.to_s
  end
end

def execute(sql)
  sql = sql.to_sql unless sql.is_a?(String)
  ActiveRecord::Base.connection.select_all(sql)
end

def go(file='console')
  load "/Users/glongman/#{file}.rb"
end



def ppj(json_string)
  hash =  (json_string.is_a?(Hash) || json_string.is_a?(Array)) ? json_string : JSON.parse(json_string)
  puts JSON.pretty_generate hash
end

def pbcopy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  pbcopy content
end

def pbpaste
  `pbpaste`
end

def change_log(stream)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
  stream.nil? ? :OFF : :ON·
end

def show_log
  change_log(STDOUT)
end

def hide_log
  change_log(nil)
end

load File.dirname(__FILE__) + '/.railsrc' if ($0 == 'irb' && ENV['RAILS_ENV']) || ($0 == 'script/rails' && Rails.env)
