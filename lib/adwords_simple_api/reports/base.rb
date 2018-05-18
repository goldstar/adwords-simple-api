require 'csv'
require 'json'
require 'date'

module AdwordsSimpleApi
  module Reports
    class Base

      def self.report_definition(value)
        @report_definition = value
      end

      def report_definition=(value)
        @report_definition = value
      end

      def report_definition
        @report_definition || self.class.instance_variable_get("@report_definition")
      end

      def self.json_columns(*columns)
        @json_columns = columns
      end

      def json_columns
        self.class.instance_variable_get("@json_columns") || []
      end

      def self.string_columns(*columns)
        @string_columns = columns
      end

      def string_columns
        self.class.instance_variable_get("@string_columns") || []
      end

      def self.integer_columns(*columns)
        @integer_columns = columns
      end

      def integer_columns
        self.class.instance_variable_get("@integer_columns") || []
      end

      def self.float_columns(*columns)
        @float_columns = columns
      end

      def float_columns
        self.class.instance_variable_get("@float_columns") || []
      end

      def self.currency_columns(*columns)
        @currency_columns = columns
      end

      def currency_columns
        self.class.instance_variable_get("@currency_columns") || []
      end

      def self.date_columns(*columns)
        @date_columns = columns
      end

      def date_columns
        self.class.instance_variable_get("@date_columns") || []
      end

      def self.include_zero_impressions(value)
        @include_zero_impressions = value
      end

      def include_zero_impressions
        izp = self.class.instance_variable_get("@include_zero_impressions")
        izp = true if izp.nil? # True is the default
        izp
      end

      def self.adwords
        AdwordsSimpleApi.adwords
      end

      def self.download_report(definition, include_zero_impressions)
        adwords.skip_report_header = true
        adwords.skip_column_header = false
        adwords.skip_report_summary = true
        adwords.include_zero_impressions = include_zero_impressions
        report_utils = adwords.report_utils(AdwordsSimpleApi::API_VERSION)
        report_utils.download_report(definition, nil)
      end

      def csv
        self.class.csv(report_definition, include_zero_impressions)
      end

      def self.csv(definition, include_zero_impressions)
        csv_string = download_report(definition, include_zero_impressions)
        CSV.parse(csv_string, {:headers => true, :header_converters => :symbol})
      end

      def to_a
        a = csv.map(&:to_h); # turn each row into a plain hash
        a.each do |row|

          # Transform json columns
          json_columns.each do |column|
            row[column] = begin
              JSON.parse(row[column].to_s)
            rescue JSON::ParserError
              nil
            end # begin
          end

          # Transform integer columns
          integer_columns.each do |column|
            row[column] = row[column].to_i if row[column]
          end

          # Transform float columns
          float_columns.each do |column|
            row[column] = row[column].to_f if row[column]
          end

          # Transform currency columns
          currency_columns.each do |column|
            row[column] = row[column].to_f / 1000000.0
          end

          date_columns.each do |column|
            row[column] = Date.parse(row[column]) if row[column]
          end

          string_columns.each do |column|
            row[column] = nil if row[column].to_s == ' --'
            row[column] = row[column].to_s if row[column]
          end
        end
        return a
      end

    end
  end
end
