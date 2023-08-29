class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :content, :active_status
  belongs_to :user, serializer: UserSerializer
end