require File.dirname(__FILE__) + '/../lib/csv_line_parser'
describe CsvLineParser::Parser do

  before(:each) do
    @row = {name: "chandresh", categories: "People"}
    @model_name = "prospect"
    @association_array = [{name: "categories", data: "name"}]
    @column_replacements =
        {"name" => "prospect_name",
         "dummy" => "more_dummy"
        }
    @combinations = [
          {
              "name" => "name",
              "part1" => "first_name",
              "part2" => "last_name"
          }
        ]
  end

  describe "#new" do
    it "should initialize when provided with required..." do
      CsvLineParser::Parser.new(@row, @model_name)
    end
  end

  describe "#replace_column_names" do
    it "should replace column names as provided" do
      csv = CsvLineParser::Parser.new(@row, @model_name, [], @column_replacements)
      csv.process.should == {prospect: [{prospect_name: "chandresh", categories: "People"}]}
    end
  end

  describe "#combine_column_names" do
    it "should combine column names as provided" do
      @row = {first_name: "chandresh", last_name: "pant", categories: "People"}
      csv = CsvLineParser::Parser.new(@row, @model_name, [], [], @combinations)
      csv.process.should == {prospect: [{name: "chandresh pant", categories: "People"}]}
    end
  end

  describe "#process" do
    it "it returns a hash containing key as model name and value as an hash of all values if no association array is provided" do
      CsvLineParser::Parser.new(@row, @model_name).process.should == {prospect: [{name: "chandresh", categories: "People"}]}
    end

    it "it returns a hash containing key as model name and value as an hash of all values except the associations" do
      CsvLineParser::Parser.new(@row, @model_name, @association_array).process[:prospect].should == [{name: "chandresh"}]
    end

    it "it returns a hash of hashes with keys as model name and value as an hash of all values" do
      @row = {name: "chandresh", categories: "People, Animals"}
      CsvLineParser::Parser.new(@row, @model_name, @association_array).process.should == {prospect: [{name: "chandresh"}],
                                                                                          categories: [{name: "People"}, {name: "Animals"}]}
    end

    it "it does not give errors if a row is passed without association data" do
      @row = {name: "chandresh"}
      CsvLineParser::Parser.new(@row, @model_name, @association_array).process.should == {prospect: [{name: "chandresh"}]}
    end

    it "it does not give errors if a row is passed with nil association data" do
      @row = {name: "chandresh", notes: nil}
      @association_array = [{name: "categories", data: "name"}, {name: "notes", data: "body"}]
      CsvLineParser::Parser.new(@row, @model_name, @association_array).process.should == {prospect: [{name: "chandresh"}],
                                                                                                    notes: []}
    end

    it "Test with a larger sample" do
      @association_array = [{name: "categories", data: "name"}, {name: "tags", data: "name"}, {name: "reference", data: "name"}]
      @row = {name: "chandresh", email: "cp@cpant.in", categories: "People, Animals", reference: "Rahul"}
      CsvLineParser::Parser.new(@row, @model_name, @association_array, @column_replacements).process.should ==
          {prospect: [{prospect_name: "chandresh", email: "cp@cpant.in"}],
           categories: [{name: "People"}, {name: "Animals"}],
           reference: [{name: "Rahul"}]
          }
    end

  end

end
