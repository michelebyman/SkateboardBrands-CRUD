class Brand < ApplicationRecord

        validates :name, presence: true
        validates :description, presence: true
        has_one_attached :avatar

        before_create :grab_image

        def grab_image
                self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_skatepusher.png')), filename: 'default_skatepusher.png', content_type: 'image/png')

        end


end
