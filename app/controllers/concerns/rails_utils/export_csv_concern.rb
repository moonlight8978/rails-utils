require "action_pack"

# TODO: Write tests
module RailsUtils
  module ExportCsvConcern
    extend ActiveSupport::Concern

    included do
      include ZipTricks::RailsStreaming
    end

    def stream_zip(filename, &block)
      # https://piotrmurach.com/articles/streaming-large-zip-files-in-rails/
      setup_streaming_headers(filename, "application/zip")

      zip_tricks_stream do |zip|
        write_file_to_zip = proc do |filename, export|
          zip.write_deflated_file(filename, &export)
        end
        yield write_file_to_zip
      end
    ensure
      response.stream.close
    end

    def stream_csv(filename, &block)
      # https://stackoverflow.com/questions/52833450/rails-exporting-a-huge-csv-file-consumes-all-ram-in-production
      setup_streaming_headers(filename, "text/csv")

      self.response_body = Enumerator.new(&block)
    end

    private

    def setup_streaming_headers(filename, mime)
      disposition = ActionDispatch::Http::ContentDisposition.format(disposition: "attachment", filename: filename)

      response.headers["Content-Disposition"] = disposition
      response.headers["Content-Type"] = mime
      # Tell Rack to stream the content
      response.headers.delete("Content-Length")
      # Don't cache anything from this generated endpoint
      response.headers["Cache-Control"] = "no-cache"
      # this is a hack to preven middleware from buffering
      response.headers["Last-Modified"] = Time.current.httpdate
      # Don't buffer when going through proxy servers
      response.headers["X-Accel-Buffering"] = "no"

      response.status = 200
    end
  end
end
