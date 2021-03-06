class Charity < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  has_many :causes_charities
  has_many :causes, through: :causes_charities
  accepts_nested_attributes_for :causes_charities

  has_many :recipients
  has_many :needs
  has_many :need_items, through: :recipients
  has_many :donation_items, through: :need_items
  has_many :donations, through: :donation_items
  has_many :user_roles
  has_many :users, through: :user_roles
  belongs_to :status

  has_attached_file :charity_photo, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    large: '600x600>'
  }, default_url: "https://s3.amazonaws.com/tinystays/avatar-missing.jpeg"

  validates_attachment_content_type :charity_photo, :content_type => /\Aimage\/.*\Z/

  before_create :create_slug

  default_scope  { order(:name => :asc) }

  def create_slug
    self.slug = self.name.parameterize
  end

  def active?
    status_id == 1
  end

  def suspended?
    status_id == 3
  end

  def inactive?
    status_id == 2
  end

  def self.all_active_charities
    where(status_id: 1)
  end

  def self.all_inactive_charities
    where(status_id: 2)
  end

  def self.all_suspended_charities
    where(status_id: 3)
  end

  def self.all_pending_charities
    where("status_id = ? AND created_at > ?", 2, 2.weeks.ago)
  end

  def associated_recipient?(recipient_id)
    recipient_ids = recipients.pluck(:id)
    if recipient_ids.include?(recipient_id)
      true
    else
      false
    end
  end

  def active_recipients
    recipients.find_all { |recipient| !recipient.active_need_items.empty? }
  end

  def create_charity_owner(user)
    role = Role.find_by(name: "Business Owner")
    user_roles.create(user: user, role: role)
  end

  def self.need_items
    join(needs: :need_item)
  end

  def self.donations
    need_items.joins(:donation_items).joins(:donations)
  end

end
