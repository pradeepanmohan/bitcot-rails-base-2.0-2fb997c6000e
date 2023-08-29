class User < ApplicationRecord
  rolify
  audited
  has_paper_trail
  searchkick

  mount_uploader :photo_path, ImageUploader

  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :confirmable, :rememberable, :validatable,:lockable,
         :jwt_authenticatable, jwt_revocation_strategy: self, omniauth_providers: [:facebook, :google_oauth2]


  enum name: { user: 'user', admin: 'admin' }
  enum active_status: [:active, :inactive, :deleted]

  has_many :posts, dependent: :destroy
  has_many :access_keys
  has_one_attached :image
  before_save :set_dynamic_link, if: :first_name_changed?

  validate :password_complexity

  validates_length_of :first_name, maximum: 64, minimum: 2
  validates_length_of :last_name, maximum: 64, minimum: 2
  validates :email, presence: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
  def full_name
    "#{first_name} #{last_name}"
  end

  has_many :devices, dependent: :destroy

  def self.from_omniauth(auth)
    name_split = auth.info.name.split(" ")
    user = User.where(email: auth.info.email).first
    user ||= User.create!(provider: auth.provider, uid: auth.uid, last_name: name_split[0], first_name: name_split[1], email: auth.info.email, password: Devise.friendly_token[0, 20], remote_photo_url: auth.info.image)
    user
  end

   def photo_urls
    if photo_path.blank?
      {}
    else
      {
          original: generate_url(BaseApp::Settings::AssetStore.cloudfront_url, photo_path),
          medium: generate_url(BaseApp::Settings::AssetStore.cloudfront_url, photo_path, '/fit-in/300x300'),
          small: generate_url(BaseApp::Settings::AssetStore.cloudfront_url, photo_path, '/fit-in/150x150'),
      }
    end
  end


  # def set_dynamic_link
  #   unless self.email.blank?
  #     # self.dynamic_link = FirebaseDynamicLinks.new('https://www.paxxie.com', {type: :ta, user_id: self.id}, self).create['short_link']
  #     self.dynamic_link = BaseApp::Platform::Branch.create_profile_url(self)
  #   end
  # end

  def set_dynamic_link
    unless email.blank?
      self.dynamic_link = generate_dynamic_link(self)
    end
  end

  def generate_dynamic_link(user)
    # Implement your custom logic here to generate the dynamic link
    # Example:
    base_url = 'https://www.example.com'
    params = { type: :ta, user_id: user.id }
    dynamic_link = "#{base_url}?#{params.to_query}"
    dynamic_link
  end


  def generate_url(base, path, filters = nil)
    url = base
    if filters.blank?
      url += path
    else
      url += filters
      url += path
    end
    url
  end


  def jwt_payload
    super
    #super.merge('foo' => 'bar')
  end

  default_scope { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.now)
  end

  def restore
    update(deleted_at: nil)
  end

  def deleted?
    !deleted_at.nil?
  end

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/

    errors.add(:password, 'must include at least one uppercase letter, one lowercase letter, one number, and one special character')
  end

  def self.search(params)
    params[:query].blank? ? all : where(
      "firstname LIKE :query OR lastname LIKE :query OR email LIKE :query", "%#{sanitize_sql_like(params[:query])}%"
    )
  end

end
