# frozen_string_literal: true

module UuidPrimaryKey
  def self.included(klass)
    klass.before_create :generate_id
  end

  def generate_id
    self.id = loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?(id: uuid)
    end
  end
end
