import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'
import moment from "moment"

export default class extends Controller {
  static targets = [
    'adultsInput',
    'bookingTypeOptions',
    'childrenInput',
    'divLodgings',
    'divRooms',
    'fromDateInput',
    'lodgingsPanel',
    'lodgingRadioButton',
    'partyHallOption',
    'priceCalculationNotice',
    'priceDiv',
    'pricePreview',
    'priceSection',
    'roomsPanel',
    'shownPriceInput',
    'tierButton',
    'tierPricingForRooms',
    'tierPricingForLodgings',
    'tierInput',
    'tierRoomsRadioButton',
    'tierLodgingsRadioButton',
    'toDateInput'
  ]

  connect() {
    console.log('connect public/booking')
  }

  initialize() {
    console.log('initialize public/booking', this.getSelectedBookingType())
    this.drawForm()
  }

  drawForm(e) {
    this.toggleLodgingsDiv()
    this.toggleRoomsDiv()
    this.togglePriceDetails()
    this.togglePartyHallOption()
  }

  getFromDate() {
    return moment(this.fromDateInputTarget.value)
  }

  getPeopleCount() {
    const adults = parseInt(this.adultsInputTarget.value) || 0
    const children = parseInt(this.childrenInputTarget.value) || 0
    return adults + children
  }

  getToDate() {
    return moment(this.toDateInputTarget.value)
  }

  getSelectedBookingType() {
    return this.bookingTypeOptionsTargets.find(button => button.checked).value
  }

  getSelectedLodging() {
    const selectedLodging = this.lodgingRadioButtonTargets.filter(radio => radio.checked)[0]
    return selectedLodging || null
  }

  setToDate(e) {
    const dayAfterFromDate = this.getFromDate().add(1, 'day')
    this.toDateInputTarget.setAttribute('min', dayAfterFromDate.format('YYYY-MM-DD'))
    if (this.toDateInputTarget.value == "") {
      this.toDateInputTarget.value = dayAfterFromDate.format('YYYY-MM-DD')
    }
    if (this.getToDate() <= this.getFromDate()) {
      this.toDateInputTarget.value = ""
    }
  }

  setInputValue(input, value) {
    console.log('set input value', input, value)
    input.value = value
  }

  showPricePreview(amount) {
    console.log('showPricePreview', amount)
    this.pricePreviewTarget.innerHTML = (amount / 100) + ' €'
    this.priceCalculationNoticeTarget.classList.add('hidden')
    this.priceDivTarget.classList.remove('hidden')
  }

  hideTierPricing() {
    this.tierPricingTarget.classList.add('hidden')
  }

  showTierPricing() {
    this.tierPricingTarget.classList.remove('hidden')
  }

  toggleLodgingsDiv() {
    if (this.forLodging()) {
      this.divLodgingsTarget.classList.replace('hidden', 'block')
    } else {
      this.divLodgingsTarget.classList.replace('block', 'hidden')
    }
  }

  toggleRoomsDiv() {
    if (this.forLodging()) {
      this.divRoomsTarget.classList.replace('block', 'hidden')
    } else {
      this.divRoomsTarget.classList.replace('hidden', 'block')
    }
  }

  togglePriceDetails() {
    this.togglePriceCalculationNotice()
    this.togglePriceSection()
    this.calculatePrice()
  }

  async calculatePrice() {
    if (this.readyForPriceCalculation()) {
      const request = new FetchRequest(
        'post', 
        '/booking_prices', 
        { 
          body: JSON.stringify({ 
          booking: {
            booking_type: (this.forLodging() ? "lodging" : "rooms"),
            lodging_id: this.lodgingRadioButtonTargets.filter(radio => radio.checked)[0].value,
            tier_lodgings: this.tierLodgingsRadioButtonTargets.filter(radio => radio.checked)[0].value,
            tier_rooms: this.tierRoomsRadioButtonTargets.filter(radio => radio.checked)[0].value,
            from_date: this.fromDateInputTarget.value,
            to_date: this.toDateInputTarget.value,
            adults: parseInt(this.adultsInputTarget.value) || 0,
            children: parseInt(this.childrenInputTarget.value) || 0
          }
        }) 
      })
      const response = await request.perform()
      if (response.ok) {
        const body = await response.text
        const amount = JSON.parse(body).amount
        console.log('calculated price', amount)
        this.togglePrice(amount)
      }
    }
  }

  togglePrice(amount) {
    if (amount > 0) {
      console.log('amount > 0')
      this.pricePreviewTarget.innerHTML = (amount / 100) + ' €'
      this.setInputValue(this.shownPriceInputTarget, amount)
      this.priceDivTarget.classList.replace('hidden', 'block')
    } else {
      console.log('amount <= 0')
      this.priceDivTarget.classList.replace('block', 'hidden')
    }
  }

  togglePriceCalculationNotice() {
    if (this.readyForPriceCalculation()) {
      this.priceCalculationNoticeTarget.classList.replace('block', 'hidden')
      console.log('readyForPriceCalculation')
    } else {
      this.priceCalculationNoticeTarget.classList.replace('hidden', 'block')
      console.log('!readyForPriceCalculation')
    }
  }

  togglePriceSection() {
    if (this.readyForPriceCalculation()) {
      this.priceSectionTarget.classList.replace('hidden', 'block')
      if (this.forLodging()) {
        this.tierPricingForLodgingsTarget.classList.replace('hidden', 'block')
        this.tierPricingForRoomsTarget.classList.replace('block', 'hidden')
      } else {
        this.tierPricingForLodgingsTarget.classList.replace('block', 'hidden')
        this.tierPricingForRoomsTarget.classList.replace('hidden', 'block')
      }
    } else {
      this.priceSectionTarget.classList.replace('block', 'hidden')
      this.tierPricingForLodgingsTarget.classList.replace('block', 'hidden')
      this.tierPricingForRoomsTarget.classList.replace('block', 'hidden')
    }
  }

  readyForPriceCalculation() {
    if (this.forLodging()) {
      return this.getFromDate().isValid() && this.getToDate().isValid() && this.getPeopleCount() > 0 && this.getSelectedLodging() !== null
    } else {
      return this.getFromDate().isValid() && this.getToDate().isValid() && this.getPeopleCount() > 0
    }
  }

  forLodging() {
    return this.getSelectedBookingType() == 'lodging'
  }

  // show 'Party Hall' section only when available
  togglePartyHallOption() {
    const selectedLodging = this.lodgingRadioButtonTargets.filter(radio => radio.checked)[0]
    if (selectedLodging !== undefined) {
      const availability = selectedLodging.dataset.bookingPartyHallAvailabilityParam
      if (availability) {
        this.partyHallOptionTarget.classList.replace('hidden', 'block')
      } else {
        this.partyHallOptionTarget.classList.replace('block', 'hidden')
      }
    }
  }
}
