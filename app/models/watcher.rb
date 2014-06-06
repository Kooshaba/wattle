class Watcher < ActiveRecord::Base
  RESTRICT_DOMAIN = ENV['RESTRICT_DOMAIN'] || Secret.restrict_domain || ""

  EMAIL_REGEX = /@#{Regexp.escape Watcher::RESTRICT_DOMAIN}\z/

  validates :email, :format => {:with => EMAIL_REGEX }, :unless => Proc.new {RESTRICT_DOMAIN.blank? }, :on => :create
  has_many :notes

  class << self

    def find_or_create_from_auth_hash!(auth_hash)
      where(email: auth_hash[:email]).first_or_create!(auth_hash.slice(:first_name, :name))
    end
  end

  def display_name
    first_name || name || email
  end
end
