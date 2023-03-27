module FastUpdate
  class DownloadXlsxFilesJob < ActiveJob::Base

    # @param start_date [ActiveSupport::TimeWithZone] The time object. You can use Time.zone.parse("date string")
    # @param end_date [ActiveSupport::TimeWithZone] The time object. You can use Time.zone.parse("date string")
    # Default behaviour is to select changes from 2-3 months ago. It takes about 3 months for the FAST Changes
    # to get into the API, which we use to update metadata.
    def perform(start_date = 3.month.ago, end_date = 2.month.ago)

      download_dir = "./public/fast_update/downloads"
      fast_url = "http://fast.oclc.org/fastChanges"

      # Parse FAST Changes site using Nokogiri
      document = Nokogiri::HTML.parse(URI.open(fast_url))
      # Search for the table
      table = document.search('table').first
      # Omit the first row since it's actually a header
      rows = table.search('tr')[1...]
      recent_changes = rows.select { |row| Time.zone.parse(row.children[1].text).between?(start_date, end_date) }
      recent_changes.each do |row|
        filename = row.search('a')[0][:href]
        dest = "#{download_dir}/#{filename}"
        next if File.file?(dest) or filename.nil?
        open(dest,'wb') do |file|
          file << URI.open("#{fast_url}/#{filename}").read
        end
      end
    end
  end
end