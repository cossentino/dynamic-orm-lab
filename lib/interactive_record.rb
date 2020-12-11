require_relative "../config/environment.rb"
require 'active_support/inflector'
require "pry"


class InteractiveRecord

    def initialize(attribute_hash={})
        attribute_hash.each do |attr, value|
          self.class.attr_accessor attr.to_sym
          self.send("#{attr}=", value)
        end
    end

    def self.table_name
        self.to_s.downcase.pluralize
    end

    def self.column_names
        sql = <<-SQL
        PRAGMA table_info(#{self.table_name})
        SQL

        cols = DB[:conn].execute(sql).collect { |col| col['name'] }
    end

    def table_name_for_insert
        self.class.table_name
    end

    
    def col_names_for_insert
        self.class.column_names[1..-1].join(", ")
    end

    #INSERT INTO students (col_names) VALUES (?)
    "'val_1', 'val_2' ..."
    def values_for_insert
        values = []
        self.class.column_names[1..-1].each do |col|
            values << "'#{send(col)}'" unless send(col).nil?
        end
        values.join(", ")
    end

    def save
        sql = <<-SQL
            INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) 
            VALUES (#{values_for_insert})
            SQL
        DB[:conn].execute(sql)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
    end

    def self.find_by_name(name)
         sql = <<-SQL
            SELECT * FROM #{self.table_name} WHERE name = ?
            SQL

        DB[:conn].execute(sql, name)
        
    end

    def self.find_by(attr_hash)

        col = attr_hash.keys[0].to_s
        val = attr_hash.values[0].to_s

        sql = "SELECT * FROM #{self.table_name} WHERE ? = ?"
        sql = "SELECT * FROM #{self.table_name} WHERE #{col} = '#{val}'"
        
    

        return_array = DB[:conn].execute(sql)

    end

  
end
