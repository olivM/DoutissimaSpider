class Node
	include Mongoid::Document
	field :url, type: String
	field :type, type: String
	field :name, type: String
	field :body, type: String
	field :fetched, type: Boolean, default: false
	field :parsed, type: Boolean, default: false
	field :ignored, type: Boolean, default: false
	field :id, type: Integer
	field :random, type: Integer

	validates_presence_of :url
	validates_uniqueness_of :url

	#embedded_in :doctor, class_name: "Doctor", inverse_of: :node

	after_create :check
	after_save :set_random
	before_save :remove_hash

	def remove_hash
		self.url.gsub(/#.*$/, '')
	end

	def set_random
		self.set(random: rand(99999999999))
	end

	@@agent = Mechanize.new

	def check

		p self.url

		if path = self.url.match(/^\/medico\/([\w\d\-\+]+)\-(\d+)$/)
			self.type = 'medicos'
			self.name = path[2]
			self.id = path[1]
			puts "MEDICOS"
		end

		if path = self.url.match(/^\/centro-medico\/([\w\d\-\+]+)\-(\d+)$/)
			self.type = 'hospital'
			self.name = path[2]
			self.id = path[1]
		end

		if path = self.url.match(/^\/sitemap\/medicos\/estado\/([\w\d\-\+]+)\-(\d+)(\/\d+)?$/)
			self.type = 'estados'
			self.name = path[2]
			self.id = path[1]
		end

		if path = self.url.match(/^\/sitemap\/medicos\/estados\/([\w\d\-\+]+)\-(\d+)\/([\w\d\-\+]+)\-(\d+)(\/\d+)?$/)
			self.type = 'estados-specialidad'
		end
		if path = self.url.match(/^\/medicos\/especialidade\/([\w\d\-\+]+)\-(\d+)(\/\d+)?$/)
			self.type = 'especialidade'
		end


		if path = self.url.match(/^\/medicos\/especialidade\/([\w\d\-\+]+)\-(\d+)\/([\w\d\-\+]+)\-(\d+)\-(\d+)(\/\d+)?$/)
			self.type = 'especialidade-city'
		end


		if path = self.url.match(/^\/medicos\/especialidade\/([\w\d\-\+]+)\-(\d+)\/([\w\d\-\+]+)\-(\d+)\/([\w\d\-\+]+)\-(\d+)\-(\d+)(\/\d+)?$/)
			self.type = 'especialidade-city'
		end


		if self.type.nil?

			self.ignored = true
			puts self.url

		end

		self.save

	end

	def get_body

		unless self.fetched

			begin
				url = "http://webcache.googleusercontent.com/search?q=cache:http://www.doctoralia.com.br#{CGI::escape(self.url)}"

				page = @@agent.get(url)

				self.body = page.body
				self.fetched = true
				self.save
			rescue
				puts "failed to parse #{url}"
				self.ignored = true
				self.save
			end

		end

		self.body

	end

	def process

		doc = Nokogiri::HTML.parse(self.get_body)

		doc.css('a').each do |link|
			href = link.attr('href')
			Node.create(url: href.gsub(/http:\/\/[^\/]+\//, '/'))	unless href.nil?
		end

		case self.type
		when 'doctor'
			Doctor.create(node: self)
		end

		self.parsed = true
		self.save

		Node.summary

	end

	def self.summary

		puts "node count : #{Node.where(parsed: true).count} / #{Node.where(fetched: true).count} / #{Node.where(ignored: false).count} / #{Node.count}"

		Node.distinct(:type).each do |type|

			puts "#{Node.where(type: type).count} #{type}"

		end

	end

end
