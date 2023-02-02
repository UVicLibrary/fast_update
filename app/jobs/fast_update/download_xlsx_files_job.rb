module FastUpdate
  class DownloadXlsxFilesJob < ActiveJob::Base

    # @param start_date [ActiveSupport::TimeWithZone] The time object. You can use Time.zone.parse("date string")
    # @param end_date [ActiveSupport::TimeWithZone] The time object. You can use Time.zone.parse("date string")
    # Default behaviour is to select changes from 2-3 months ago. It takes about 3 months for the FAST Changes
    # to reach the API, which we use to update metadata.
    def perform(start_date = 2.month.ago, end_date = 1.month.ago)

      download_dir = Rails.root.join('public','fast_update','downloads')
      fast_url = "http://fast.oclc.org/fastChanges"

      FileUtils.mkdir_p(download_dir) unless Dir.exist?(download_dir)
      # Parse FAST Changes site using Nokogiri
      document = Nokogiri::HTML.parse(URI.open(fast_url))
      # Search for the table
      table = document.search('table').first
      # Omit the first row since it's actually a header
      rows = table.search('tr')[1...]
      recent_changes = rows.select { |row| Time.zone.parse(row.children[1].text).between?(start_date, end_date) }
      filenames = recent_changes.each_with_object([]) do |row, array|
        filename = row.search('a')[0][:href]
        dest = "#{download_dir}/#{filename}"
        unless File.file?(dest) or filename.nil?
          open(dest,'wb') do |file|
            file << URI.open("#{fast_url}/#{filename}").read
          end
        end
        array << dest
      end
      ParseChangesJob.perform_later(filenames)
    end
  end
end