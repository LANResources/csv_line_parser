require "csv_line_parser/version"

module CsvLineParser
  class Parser

    def initialize(line, model_name, association_array=[], column_replacements=[], combinations=[])
      @line = line.dup
      @model_name = model_name
      @association_array = association_array
      @column_replacements = column_replacements
      @combinations = combinations
    end

    def process
      combine_columns
      replace_column_names
      hashed_line = {}
      @association_array.each do |association|
        next unless @line.has_key?(association[:name].to_sym) # no point going further if the hash does not has the key!
        values = @line.delete(association[:name].to_sym)
        values_arr = []
        values.to_s.split(',').each do |value|
          values_arr << {association[:data].to_sym => value.strip}
        end
        hashed_line = hashed_line.merge({association[:name].to_sym => values_arr})
      end
      hashed_line.merge({@model_name.to_sym => [@line]})
    end

    def combine_columns
      @combinations.each do |combination|
        part1 = @line.delete(combination["part1"].to_sym)
        part2 = @line.delete(combination["part2"].to_sym)
        if (combined_value = [part1, part2].join(' ')).present?
          @line = @line.merge({combination["name"].to_sym => combined_value})
        end
      end
    end

    def replace_column_names
      @column_replacements.each do |current_name,new_name|
        next unless @line.has_key? current_name.to_sym
        value = @line.delete(current_name.to_sym)
        @line = @line.merge({new_name.to_sym => value})
      end
      @line
    end

  end
end
