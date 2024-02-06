# == Schema Information
#
# Table name: spaces
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string
#  deleted_at  :datetime
#
class Space < ApplicationRecord
  has_many :space_reservations

  has_soft_deletion default_scope: true

  def booked_on?(date)
    SpaceReservation.includes(:space_booking)
                    .where(
                      date: date,
                      space: self.id,
                      space_booking: { status: "confirmed" }
                    ).exists?
  end
end
