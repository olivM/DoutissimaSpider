
require './crawler.rb'

namespace :crawl do
	desc "test"
	task :test do

		puts Time.now.to_s.yellow
		puts __FILE__

		# don't overlap
		myself = File.new __FILE__
		unless  myself.flock File::LOCK_EX | File::LOCK_NB
		  abort "You're already running a crawling process! Know a patience."
		end

		# Create a new instance of Mechanize and grab our page
		agent = Mechanize.new
		page = agent.get('http://webcache.googleusercontent.com/search?q=cache:http://www.doctoralia.com.br/sitemap/medicos')

		# Find all the links on the page that are contained within
		# h1 tags.
		page.parser.css('a').each do |link|
			p link.attr('href')
			Node.new(link.attr('href'))
		end


	end

end

