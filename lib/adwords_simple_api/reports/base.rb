require 'csv'
require 'json'

module AdwordsSimpleApi
  module Reports
    class Base

      def self.report_defination(value)
        @report_defination = value
      end

      def report_defination=(value)
        @report_defination = value
      end

      def report_defination
        @report_defination || self.class.instance_variable_get("@report_defination")
      end

      def self.json_columns(*columns)
        @json_columns = columns
      end

      def json_columns
        self.class.instance_variable_get("@json_columns") || []
      end

      def self.integer_columns(*columns)
        @integer_columns = columns
      end

      def integer_columns
        self.class.instance_variable_get("@integer_columns") || []
      end

      def self.currency_columns(*columns)
        @currency_columns = columns
      end

      def currency_columns
        self.class.instance_variable_get("@currency_columns") || []
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
        @adwords ||= AdwordsSimpleApi.adwords
      end

      def self.download_report(defination, include_zero_impressions)
        adwords.skip_report_header = true
        adwords.skip_column_header = false
        adwords.skip_report_summary = true
        adwords.include_zero_impressions = include_zero_impressions
        report_utils = adwords.report_utils(AdwordsSimpleApi::API_VERSION)
        report_utils.download_report(defination, nil)
      end

      def csv
        self.class.csv(report_defination, include_zero_impressions)
      end

      def self.csv(defination, include_zero_impressions)
        csv_string = download_report(defination, include_zero_impressions)
        CSV.parse(csv_string, {:headers => true, :header_converters => :symbol})
      end

      def to_a
        a = csv.map(&:to_h); # turn each row into a plain hash
        a.each do |row|

          # Transform json columns
          json_columns.each do |column|
            row[column] = begin
              JSON.parse(row[column])
            rescue JSON::ParserError
              nil
            end # begin
          end

          # Transform integer columns
          integer_columns.each do |column|
            row[column] = row[column].to_i
          end

          # Transform currency columns
          currency_columns.each do |column|
            row[column] = row[column].to_f / 1000000.0
          end

        end
        return a
      end

    end
  end
end
