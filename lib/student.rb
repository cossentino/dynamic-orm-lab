require_relative "../config/environment.rb"
require 'active_support/inflector'
require_relative './interactive_record.rb'
require "pry"

class Student < InteractiveRecord



end


Student.new({name: "Susan", grade: 10}).save
Student.new({name: "Geraldine", grade: 9}).save

