import { combineReducers } from 'redux'
import { holidays, holidaysLoading, holidaysThisWeek, primaryHoliday } from './holidays'
import { location, locationLoading, locale } from './location'
import { gif, gifLoading } from './gif'

export default combineReducers {
  holidaysLoading
  holidays
  holidaysThisWeek
  primaryHoliday

  locationLoading
  location
  locale

  gifLoading
  gif
}
