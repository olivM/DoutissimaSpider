class Doctor
	include Mongoid::Document
	field :url, type: String
	field :type, type: String
	field :name, type: String
	field :id, type: Integer

	validates_presence_of :url
	validates_uniqueness_of :url

 	embeds_one :node, class_name: "Node", inverse_of: :doctor

	after_create :parse

	@@agent = Mechanize.new

	def parse

		p self.node

		doc = Nokogiri::HTML.parse(self.node.get_body)

		p doc.at('#CM_TagNombreMedico')

		p doc.css('#CM_TagNombreMedico')

		self.node.parsed = true
		self.node.save

	end

end
