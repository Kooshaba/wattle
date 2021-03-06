class Watcher < ActiveRecord::Base
  serialize :default_filters
  serialize :email_filters
  RESTRICT_DOMAIN = ENV['RESTRICT_DOMAIN'] || Secret.restrict_domain || ""

  EMAIL_REGEX = /@#{Regexp.escape Watcher::RESTRICT_DOMAIN}\z/

  validates :email, :format => {:with => EMAIL_REGEX }, :unless => Proc.new {RESTRICT_DOMAIN.blank? }, :on => :create
  has_many :notes
  has_many :grouping_unsubscribes, dependent: :destroy

  has_many :grouping_owners, dependent: :destroy
  has_many :owned_groupings, through: :grouping_owners, source: :grouping

  class << self
    def find_or_create_from_auth_hash!(auth_hash)
      where(email: auth_hash[:email]).first_or_create!(auth_hash.slice(:first_name, :name))
    end
  end


  state_machine :state, initial: :active do
    state :active, :inactive

    event :activate do
      transition any => :active
    end

    event :deactivate do
      transition any => :inactive
    end
  end

  scope :active, -> { where(state: :active)}
  scope :inactive, -> { where(state: :inactive)}


  def display_name
    name || first_name ||  email
  end
end
