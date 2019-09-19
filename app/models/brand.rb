class Brand < ApplicationRecord

        validates :name, presence: true
        validates :description, presence: true
        has_one_attached :avatar

        before_create :grab_image

        def grab_image
                self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')), filename: 'default_image.png', content_type: 'image/png')
                ap 'test'
                ap self.avatar
        end


end
