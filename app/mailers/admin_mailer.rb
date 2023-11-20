class AdminMailer < ApplicationMailer
  def booking_request(booking)
    @booking = booking
    mail(
      to: "reservation@les4sources.be",
      subject: "💁‍♂️ DEMANDE DE RÉSERVATION pour un hébergement: #{@booking.name}",
      tag: "admin_booking_request"
    )
  end

  def booking_canceled(booking)
    @booking = BookingDecorator.new(booking)
    mail(
      to: "reservation@les4sources.be",
      subject: "⚠️ Réservation d'hébergement annulée: #{ActionView::Base.full_sanitizer.sanitize(@booking.group_or_name)} (#{@booking.date_range})",
      tag: "admin_booking_canceled"
    )
  end

  def space_booking_canceled(space_booking)
    @space_booking = SpaceBookingDecorator.new(space_booking)
    mail(
      to: "reservation@les4sources.be",
      subject: "⚠️ Réservation d'espaces annulée: #{ActionView::Base.full_sanitizer.sanitize(@space_booking.group_or_name)} (#{@space_booking.date_range})",
      tag: "admin_space_booking_canceled"
    )
  end
end