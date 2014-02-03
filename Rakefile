
require './crawler.rb'

namespace :crawl do
	desc "init"
	task :init do

		puts Time.now.to_s.yellow
		puts __FILE__

		# don't overlap
		myself = File.new __FILE__
		unless  myself.flock File::LOCK_EX | File::LOCK_NB
		  abort "You're already running a crawling process! Know a patience."
		end

		# Create a new instance of Mechanize and grab our page
		agent = Mechanize.new
#		page = agent.get('http://webcache.googleusercontent.com/search?q=cache:http://www.doctoralia.com.br/sitemap/medicos')

		page = agent.get("http://webcache.googleusercontent.com/search?q=cache:#{CGI::escape('http://www.doctoralia.com.br/medicos/especialidade/neurologistas-1297/bradesco+saude-63-2/brasilia-116707-1')}")

		Node.delete_all

		# Find all the links on the page that are contained within
		# h1 tags.
		page.parser.css('a').each do |link|
			# p link.attr('href')
			Node.create(url: link.attr('href').gsub(/http:\/\/[^\/]+\//, '/'))
		end

		Node.summary

	end

	desc "process"
	task :process do

		puts Time.now.to_s.yellow
		puts __FILE__

		# don't overlap
		myself = File.new __FILE__
		unless  myself.flock File::LOCK_EX | File::LOCK_NB
		  abort "You're already running a crawling process! Know a patience."
		end

		Node.distinct(:type).each do |type|

			puts "#{Node.where(type: type).count} #{type}"

			Node.where(type: type, parsed: false, ignored: false).limit(3).each do |node|
				p node.url
				node.process
			end

		end

		Node.summary

	end


	desc "parse"
	task :parse do

		puts Time.now.to_s.yellow
		puts __FILE__

		# don't overlap
		myself = File.new __FILE__
		unless  myself.flock File::LOCK_EX | File::LOCK_NB
		  abort "You're already running a crawling process! Know a patience."
		end

		Node.where(type: 'medicos', parsed: false).sort(random: 1).limit(1).each do |node|
			p node.url
			node.process
		end

		Node.summary

	end



end
