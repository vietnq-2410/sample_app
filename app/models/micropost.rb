class Micropost < ApplicationRecord
  belongs_to :user
  scope :by_created_at, ->{order(created_at: :desc)}
  scope :get_feed, ->(following_ids, id){where("user_id IN (?) OR user_id = ?", following_ids, id)}
  has_one_attached :image
  validates :content, presence: true,
              length: {maximum: Settings.validates.content_microppst}
  validates :image,
            content_type: {
              in: %i(gif png jpg jpeg),
              message: I18n.t("micropost.valid_image")
            },
            size: {
              less_than: Settings.validates.max_size_image.megabytes,
              message: I18n.t("micropost.less_size")
            }

  def display_image
    image.variant resize_to_limit: [Settings.validates.width_image,
      Settings.validates.height_image]
  end
end
